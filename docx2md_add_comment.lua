--
-- @file    docx2md_add_comment.lua
-- @brief   pandoc-comment-extractor
-- @details
--
-- ## Usage
--
-- * Use this script as a Pandoc lua filter with the following command:
-- * NOTE: Use `--track-changes=all` option for extracting docx comments.
--
-- ```sh
-- pandoc input.docx -t gfm -o output.md --track-changes=all --lua-filter=./docx2md_add_comment.lua
-- ```
--


--
-- @brief Extract comments implemented in headers
--
function Header(el)
  local comment = nil
  local non_comment_content = {}

  for _, data in ipairs(el.content) do
    if data.t == "Span" and pandoc.List(data.attr.classes):includes("comment-start") then
      local comment_parts = {}
      for _, inline_el in ipairs(data.c) do
        table.insert(comment_parts, pandoc.utils.stringify(inline_el))
      end
      comment = table.concat(comment_parts)
    else
      table.insert(non_comment_content, data)
    end
  end

  local section_title = string.rep("#", el.level) .. " " .. pandoc.utils.stringify(non_comment_content)

  if comment then
    return {
      pandoc.RawBlock("markdown", "<!-- " .. comment .. " -->\n" .. section_title)
    }
  end
  return el
end

