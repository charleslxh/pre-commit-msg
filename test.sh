#!/usr/bin/env sh

# Echo Colors
msg_color_green="\033[0;32m"
msg_color_magenta='\033[0;31m';
msg_color_yellow='\033[0;33m';
msg_color_none='\033[0m'; # No Color

num=1;
passed=0;
failed=0;
testCase() {
  description=$1;
  script=$2;
  excepExitCode=$3;

  bash ./pre_commit_hooks/check-commit-msg.sh $script > /dev/null

  if [ "$?" -eq $excepExitCode ]
  then
    let passed++
    echo "$num: $description: ${msg_color_green}✔ passed${msg_color_none}"
  else
    let failed++
    echo "$num: $description: ${msg_color_magenta}× failed${msg_color_none}\n"
    echo "      excepted exit with code ${msg_color_green}$excepExitCode${msg_color_none}, but got ${msg_color_magenta}$?${msg_color_none}.\n"
  fi

  let num++
}

testCase 'if commit message include multi lines, only validate the fiest line, e.g: run "git commit --amend".' 'test/multi_lines_commit_message' 0
testCase 'custom commit message must match "<type>(<scope>): <subject>"' 'test/custom_commit_message' 0
testCase 'merge request message is allowed, e.g: "Merge branch develop to master"' 'test/merge_commit_message' 0
testCase 'commit message must not too long, default max length: 100' 'test/message_too_long' 1
testCase 'commit message must not too short, default min length: 10' 'test/message_too_short' 1
testCase 'revert message is allowed, e.g: "Revert ...."' 'test/revert_request_message' 0
testCase 'Split message is allowed, e.g: "Split ...."' 'test/split_request_message' 0

echo "Summary:\n"
echo "    ${msg_color_green}passed count:${msg_color_none} $passed"
echo "    ${msg_color_magenta}failed count:${msg_color_none} $failed"

[ "$failed" -eq 0 ] && exit 0 || exit 1
