#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ] ; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

export TMPFILE="flakehell.out"
flakehell lint > ${TMPFILE}

echo "Contents of flakehell.out:"
echo "**********************"
cat flakehell.out
echo "**********************"


echo "Running flakehell with:"
echo "**********************"
echo 'reviewdog -efm="%f:%l:%c: %m" \
      -name="flakehell" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS} < ${TMPFILE}'
echo "**********************"

reviewdog -efm="%f:%l:%c: %m" \
      -name="flakehell" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS} < ${TMPFILE}
