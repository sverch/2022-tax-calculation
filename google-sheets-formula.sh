#!/bin/bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

NUM_ARGS_REQUIRED=1
if [ $# -ne "${NUM_ARGS_REQUIRED}" ]; then
	cat <<EOF
Usage: $0 <income_cell>

    Dumps a formula to calculate 2022 taxes, suitable for dumping in google
    sheets.

EOF
	exit 1
fi

run() {
	echo "+" "$@" 1>&2
	"$@"
}

INCOME_CELL=$1
STANDARD_DEDUCTION=12950

# shellcheck disable=SC2016
FORMULA=$(awk -F$'\t' '{print $1 $2}' brackets.tsv |
	grep -v Rate |
	sed 's/more/$100000000/' |
	sed 's/to//' |
	sed 's/or//' |
	sed 's/\$//g' |
	sed 's/,//g' |
	sed 's/%//' |
	awk 'BEGIN {print "=SUM(" } {print "IF(PLACEHOLDER > " $2 ", (IF(PLACEHOLDER > " $3 ", " $3 ", PLACEHOLDER) - " $2 ") * 0." $1 ", 0)," } END {print "0)" }' |
	sed "s/PLACEHOLDER/($INCOME_CELL - $STANDARD_DEDUCTION)/g")

echo "$FORMULA"
