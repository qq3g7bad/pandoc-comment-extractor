#!/bin/bash

shell_loc="$(cd "$(dirname "$0")" && pwd)"
cd "$shell_loc"

output="$()"
expect_result="$(cat "./output.md")"

if [ "$(diff <(pandoc ./input.docx -t gfm --track-changes=all --lua-filter=../docx2md_add_comment.lua) ./output.md | wc -l)" -eq 0 ]; then
  echo "PASS"
else
  echo "FAIL"
  echo "----------"
  diff <(pandoc ./input.docx -t gfm --track-changes=all --lua-filter=../docx2md_add_comment.lua) ./output.md
fi

