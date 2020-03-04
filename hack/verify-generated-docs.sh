#!/usr/bin/env bash

# standard bash error handling
set -o nounset # treat unset variables as an error and exit immediately.
set -o errexit # exit immediately when a command fails.
set -E         # needs to be set if we want the ERR trap

readonly CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source "${CURRENT_DIR}/utilities.sh" || { echo 'Cannot load CI utilities.'; exit 1; }

generate_docs() {
    shout "Auto generate docs"
    make docs
}

check_generated_docs() {
    shout "Check that auto generated docs are up-to-date"
    result=$(git diff -U0 | grep '^[+-]' | grep -Ev '^(--- a/|\+\+\+ b/)' | grep -v '^[+-]###### Auto generated by')
    if [[ -n result ]]; then
        echo "ERROR: detected documents that need to be updated" 
        echo "
        Run:
            make docs
        in the root of the repository and commit changes.
        "
        exit 1
    else
        echo "inside else branch"
        echo -e "${GREEN}√ check that generated docs are up-to-date${NC}"
    fi
    echo "outside else branch"
}

main() {
    generate_docs
    check_generated_docs
}

main