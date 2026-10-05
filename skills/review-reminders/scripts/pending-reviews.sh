#!/usr/bin/env bash
# Lists who still owes a review on your open, non-draft PRs in one repository.
#
# Usage: pending-reviews.sh [owner/repo]   (defaults to the repo of the cwd)
# Needs: gh (authenticated), jq.
#
# A reviewer owes a review when either:
#   - GitHub lists them as a requested reviewer, or
#   - their last decisive review (APPROVED / CHANGES_REQUESTED / DISMISSED) is
#     DISMISSED, or is CHANGES_REQUESTED and a commit landed after it.
# The review is "first" if they have never reviewed the PR, else "re-review".
set -euo pipefail

repo="${1:-$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null || true)}"
if [ -z "$repo" ]; then
  echo "Not inside a GitHub repository. Pass one: pending-reviews.sh owner/repo" >&2
  exit 1
fi
me="$(gh api user --jq .login)"

read -r -d '' query <<'GRAPHQL' || true
query($q: String!) {
  search(query: $q, type: ISSUE, first: 100) {
    nodes {
      ... on PullRequest {
        number
        title
        url
        isDraft
        commits(last: 1) { nodes { commit { committedDate } } }
        reviewRequests(first: 50) {
          nodes {
            requestedReviewer {
              __typename
              ... on User { login }
              ... on Team { slug }
            }
          }
        }
        reviews(last: 100) {
          nodes { author { __typename login } state submittedAt }
        }
      }
    }
  }
}
GRAPHQL

read -r -d '' classify <<'JQ' || true
def requested:
  [.reviewRequests.nodes[].requestedReviewer
   | select(.__typename == "User" or .__typename == "Team")
   | if .__typename == "Team" then "team:\(.slug)" else .login end];

def human_reviews($me):
  [.reviews.nodes[]
   | select(.author.__typename == "User" and .author.login != $me and .state != "PENDING")];

def last_decisive($reviews; $who):
  [$reviews[] | select(.author.login == $who
     and (.state == "APPROVED" or .state == "CHANGES_REQUESTED" or .state == "DISMISSED"))]
  | last;

def status($pr; $reviews; $who):
  ([$reviews[] | select(.author.login == $who)] | length) as $prior
  | last_decisive($reviews; $who) as $decisive
  | ($pr.commits.nodes[0].commit.committedDate // "") as $last_commit
  | if ($pr | requested | index($who)) then (if $prior > 0 then "re-review" else "first" end)
    elif $decisive == null then "none"
    elif $decisive.state == "DISMISSED" then "re-review"
    elif $decisive.state == "CHANGES_REQUESTED" and $last_commit > $decisive.submittedAt then "re-review"
    elif $decisive.state == "CHANGES_REQUESTED" then "waiting-on-author"
    else "approved" end;

def rows($me):
  . as $pr
  | human_reviews($me) as $reviews
  | (requested + [$reviews[].author.login] | unique)[]
  | {reviewer: ., number: $pr.number, title: $pr.title, url: $pr.url,
     last_commit: $pr.commits.nodes[0].commit.committedDate,
     status: status($pr; $reviews; .)};

[.data.search.nodes[] | select(.isDraft | not)] as $prs
| [$prs[] | rows($me)] as $rows
| {
    repo: $repo,
    author: $me,
    reviewers: ($rows
      | map(select(.status == "first" or .status == "re-review"))
      | group_by(.reviewer)
      | map({reviewer: .[0].reviewer,
             prs: map({number, title, url, last_commit, review: .status})
                  | sort_by(.number) | reverse})),
    waiting_on_author: ($rows | map(select(.status == "waiting-on-author")) | map(del(.status))),
    nobody_owes_review: ($prs
      | map(select(.number as $n | $rows
          | map(select(.number == $n and (.status == "first" or .status == "re-review")))
          | length == 0))
      | map({number, title, url,
             approved_by: [.reviews.nodes[] | select(.state == "APPROVED") | .author.login] | unique}))
  }
JQ

gh api graphql \
  -f query="$query" \
  -f q="repo:${repo} is:pr is:open author:${me}" \
  | jq --arg me "$me" --arg repo "$repo" "$classify"
