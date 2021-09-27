
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

BACKUP=/var/run/user/$UID/last_commit.log
[[ -e  $BACKUP ]] && [[ -z "$(awk 'NR==1' $BACKUP)" ]] && rm $BACKUP
[[ -e  $BACKUP ]] && cat $BACKUP > $1 && rm $BACKUP

exit 0;
