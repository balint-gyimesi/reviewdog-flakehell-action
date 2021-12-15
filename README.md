# Description

This repo contains a GitHub action to run [flakehell](https://github.com/flakehell/flakehell).

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
      - uses: sailingpalmtree/reviewdog-flakehell-action@0.1
        with:
          github_token: ${{ secrets.github_token }}
          # Change reviewdog reporter if you need [github-pr-check,github-check,github-pr-review].
          reporter: github-pr-review
          # Change reporter level if you need.
          # GitHub Status Check won't become failure with warning.
          level: warning
```

## Release

v0.1 - first draft release
