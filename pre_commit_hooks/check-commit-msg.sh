#!/bin/bash

# Bash commit message checker.
#
# Exit 0 if no errors found
# Exit 1 if errors were found
#
# Requires
# - None
#
# Arguments
# - None

# Echo Colors
msg_color_green="\033[0;32m"
msg_color_magenta='\033[0;31m';
msg_color_yellow='\033[0;33m';
msg_color_none='\033[0m'; # No Color

# Echo Error Message
MESSAGE_TOO_SHORT="${msg_color_yellow}INVALID COMMIT MSG: commit message too short!${msg_color_none} \n"
MESSAGE_TOO_LONG="${msg_color_yellow}INVALID COMMIT MSG: commit message too long!${msg_color_none} \n"
INVALID_COMMIT_TIP="${msg_color_magenta}INVALID COMMIT MSG: does not match '<type>(<scope>): <subject>'!${msg_color_none} \n";

MIN_LENGTH=10;
MAX_LENGTH=100;

IGNORE_COMMIT_PATTERN='/\bv?(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)(?:-[\da-z-]+(?:\.[\da-z-]+)*)?(?:\+[\da-z-]+(?:\.[\da-z-]+)*)?\b/ig';
# Merge request message
MERGE_COMMIT_PATTERN='^Merge[[:space:]]+.*$';
# Revert request message
REVERT_COMMIT_PATTERN='^Revert[[:space:]]+.*$';
# Split request message, for git-subtree
SPLIT_COMMIT_PATTERN='^Split[[:space:]]+.*$';
# fixup! and squash! are part of Git, commits tagged with them are not intended to be merged, cf. https://git-scm.com/docs/git-commit
GIT_INTERNAL_PATTERN='^((fixup![[:space:]]|squash![[:space:]])?(\w+)(?:\(([^\)\s]+)\))?: (.+))(?:\n|$)';
# Custom commit message
CUSTOM_COMMIT_PATTERN='^(feature|fix|docs|style|refactor|perf|test|build|ci|chore|revert):[[:space:]]+.*$';

COMMIT_EDITMSG=$1; shift;

if [ -f "$COMMIT_EDITMSG" ]
then
  commitMessage=`head -n 1 $COMMIT_EDITMSG`;
else
  commitMessage="$COMMIT_EDITMSG"
fi

commitMessage=`echo "$commitMessage" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`

while getopts ':g:l:h' FLAG; do
  case ${FLAG} in
    g )
      MIN_LENGTH=$OPTARG;
      ;;
    l )
      MAX_LENGTH=$OPTARG;
      ;;
    h )
      echo "Options:"
      echo "    -h  Display this help message."
      echo "    -g  Sprcify the min length of commit message."
      echo "    -l  Sprcify the max length of commit message."
      echo -e "\nUsage:"
      echo "    checl-commit-msg commit_message_here -g 20 -l 150"
      exit 0
      ;;
    \? )
      echo "Invalid Option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

echo -en "Checking commit message: ${msg_color_green}$commitMessage${msg_color_none} \n";

[ ${#commitMessage} -le $MIN_LENGTH ] && echo -en "$MESSAGE_TOO_SHORT" && exit 1;
[ ${#commitMessage} -ge $MAX_LENGTH ] && echo -en "$MESSAGE_TOO_LONG" && exit 1;

patterns=(
  $IGNORE_COMMIT_PATTERN
  $MERGE_COMMIT_PATTERN
  $REVERT_COMMIT_PATTERN
  $SPLIT_COMMIT_PATTERN
  $GIT_INTERNAL_PATTERN
  $CUSTOM_COMMIT_PATTERN
);

for pattern in ${patterns[*]}
do
  if [[ $commitMessage =~ $pattern ]];
  then
    exit 0;
  fi
done

echo -en "$INVALID_COMMIT_TIP";
exit 1;
