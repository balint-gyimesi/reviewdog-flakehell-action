# Description

This repo contains a GitHub action to run [flakehell](https://github.com/flakehell/flakehell),
using [reviewdog](https://github.com/reviewdog/reviewdog) to annotate code changes on GitHub.

This action was created from `reviewdog`'s awesome [action template](https://github.com/reviewdog/action-template).

## Usage

```yaml
name: reviewdog-flakehell
on: [pull_request]
jobs:
  flakehell:
    name: runner / flakehell
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: sailingpalmtree/reviewdog-flakehell-action@0.2
        with:
          github_token: ${{ secrets.github_token }}
          # Change reviewdog reporter if you need [github-pr-check,github-check,github-pr-review].
          reporter: github-pr-review
          # Change reporter level if you need.
          # GitHub Status Check won't become failure with warning.
          level: warning
```

## Releases

v0.2 - first fully tested, and actually fully used version
v0.1 - first draft release
