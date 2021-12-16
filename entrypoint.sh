#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ]
then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

echo "Running in: ${PWD}"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"
export TMPFILE=$(mktemp)

echo "============================="
echo "Flakehell installed plugins:"
flakehell plugins

echo "============================="
echo "Flakehell config file:"
ls -la pyproject.toml
cat pyproject.toml || true

echo "============================="
echo "Sanity check, running flakehell without saving its ouput:"
flakehell lint

echo "============================="
echo "Running flakehell, saving output to tmpfile: ${TMPFILE}"
flakehell lint > "${TMPFILE}"

echo "============================="
ls -la ${TMPFILE}
echo "============================="
echo "Head of ${TMPFILE}:"
head ${TMPFILE}

echo "============================="
echo "Running reviewdog with:"
echo 'reviewdog -efm="%f:%l:%c: %m" \
      -name="flakehell" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS} < ${TMPFILE}'
echo
echo "Where vars are:"
echo "  INPUT_REPORTER=${INPUT_REPORTER}"
echo "  INPUT_FILTER_MODE=${INPUT_FILTER_MODE}"
echo "  INPUT_FAIL_ON_ERROR=${INPUT_FAIL_ON_ERROR}"
echo "  INPUT_LEVEL=${INPUT_LEVEL}"
echo "  INPUT_REVIEWDOG_FLAGS=${INPUT_REVIEWDOG_FLAGS}"
echo

echo "============================="
reviewdog -efm="%f:%l:%c: %m" \
      -name="flakehell" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS} < "${TMPFILE}"

echo "============================="
echo "Done running reviewdog, exiting..."
