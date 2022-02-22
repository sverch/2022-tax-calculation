#!/bin/bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

NUM_ARGS_REQUIRED=1
if [ $# -ne "${NUM_ARGS_REQUIRED}" ]; then
	cat <<EOF
Usage: $0 <income_cell>

    Dumps a formula to calculate 2022 dc taxes, suitable for dumping in google
    sheets.

EOF
	exit 1
fi

run() {
	echo "+" "$@" 1>&2
	"$@"
}

INCOME_CELL=$1

# I think this is similar for DC:
# https://otr.cfo.dc.gov/page/individual-income-tax-filing-faqs
STANDARD_DEDUCTION=12950

# shellcheck disable=SC2016
FORMULA=$(awk -F$'\t' '{print $3 " " $1 " " $2}' dc-brackets.tsv |
	sed 's/\$//g' |
	sed 's/%//' |
	sed 's/\,//' |
	awk 'BEGIN {print "=SUM(" } {print "IF(PLACEHOLDER > " $2 ", (IF(PLACEHOLDER > " $3 ", " $3 ", PLACEHOLDER) - " $2 ") * 0.01 * " $1 ", 0)," } END {print "0)" }' |
	sed "s/PLACEHOLDER/($INCOME_CELL - $STANDARD_DEDUCTION)/g")

echo "$FORMULA"
