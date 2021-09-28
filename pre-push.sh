#!/bin/bash -
#===============================================================================
#
#          FILE: pre-push.sh
#
#         USAGE: ./pre-push.sh
#
#   DESCRIPTION: 
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: ---, 
#  ORGANIZATION: 
#       CREATED: 09/27/2021 11:32:58 PM
#      REVISION:  ---
#===============================================================================

set -o nounset                                  # Treat unset variables as an error

function main() {
  trap endScript INT SIGINT QUIT ABRT KILL TERM STOP PWR

  printf "LOADING TESTS... (this could take a while)"
  sleep 1
  TEST_RESULTS=$(flutter test --no-pub)

  PASSED_TESTS=$(echo $TEST_RESULTS | grep -Po "[0-9]+:[0-9]+\s\K\+[0-9]+" | tail -n1)
  RAW_ERRORS=$(echo $TEST_RESULTS | grep -Po "[0-9]+:[0-9]+\s\+[0-9]+\s-[0-9]+:\s\K(_|\.|\/|[a-zA-Z0-9])+:(\s|[A-Za-z0-9]|,|\.|!|\\|/|\|\?|\`|\"|\'|\-)+\s\[E\]")

  readarray -d "[E]" -t ERRORS <<<"$RAW_ERRORS"

  [[ -z "$RAW_ERRORS" ]] && successMessage $PASSED_TESTS && exit 0

  clear
  red && bold
  echo "ERRORS WERE FOUND YOU FOOL v:< !"
  echo -e "=-----------------------------------------------------------------------------------------------------------------------=\n"
  for i in ${!ERRORS[@]}; do
    [[ $i -ge $((${#ERRORS[@]} - 1)) ]] && break
  
    err=${ERRORS[i]}
    echo -e "\tMESSAGE: $(echo $err | grep -Po '(/|[a-zA-Z]|_|\.)+:\s\K.+')"
    echo -e "\tFILE: $(echo $err | grep -Po '[/a-zA-Z_\.]+(?=:)')"
    echo ""
  done
  echo -e "=-----------------------------------------------------------------------------------------------------------------------="

  yellow
  echo -e "\n\n\tFix them before pushing again...\n"
  exit 1
}

function red() {
  printf "\e[31m"
}

function yellow() {
  printf "\e[1;33m"
}

function green() {
  printf "\e[32m"
}

function bold() {
  printf "\e[1m"

}

function reset() {
  printf "\e[0m"
}

function successMessage() {
  clear
  green
  echo "SUCCESS ✔️"
  echo "$1 - Tests Passed"
  echo ""
}

function endScript() {
  reset
}

main
