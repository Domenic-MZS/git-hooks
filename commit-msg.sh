#!/bin/bash -
#===============================================================================
#
#          FILE: commit-msg.sh
#
#         USAGE: ./commit-msg.sh
#
#   DESCRIPTION: 
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: ---, 
#  ORGANIZATION: 
#       CREATED: 09/27/2021 01:24:48 AM
#      REVISION:  ---
#===============================================================================

set -o nounset                                  # Treat unset variables as an error

# // Conventional commit check
function main(){
  [[ -z "$(awk 'NR==1' $1 | grep -Eo '(perf|build|test|refactor|feat|ci|fix|docs|chore|style)!?(\([a-zA-Z]+\))?:\s[A-Za-z\s]+')" ]] && saveBackup $1 && conventionalError
  [[ 72 -le $(awk 'NR==1' $1 | wc -m) ]] && saveBackup $1 && conventionalError
  exit 0;

}

function conventionalError() {
  echo " ------------------------------------------------------ "
  echo " | PLEASE FOLLOW THE CONVENTIONAL COMMIT GUIDELINES   | "
  echo " |                                                    | "
  echo " | 1) Start with -> refactor | feat | ci | fix | docs | "
  echo " |    chore | style | test | perf | build             | "
  echo " |                                                    | "
  echo " | 2) Add an optional \`(scope)\` after rule #1         | "
  echo " |                                                    | "
  echo " | 3) Add a short description                         | "
  echo " |                                                    | "
  echo " | 4) You could add a body and footer if u want       | "
  echo " ------------------------------------------------------ "
  echo ""
  echo "Type \`git commit\` and fix the previous commit message"
  exit 1;
}

function saveBackup() {
  CLOG=/var/run/user/$UID/last_commit.log
  [[ -e  $CLOG ]] && rm $CLOG
  cp $1 /var/run/user/$UID/last_commit.log 
} > /dev/null

main $@
