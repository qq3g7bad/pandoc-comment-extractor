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


local function format_comment_with_author(span)
  local comment_parts = {}
  for _, inline_el in ipairs(span.c or {}) do
    table.insert(comment_parts, pandoc.utils.stringify(inline_el))
  end

  local comment_text = table.concat(comment_parts)
  local author = nil

  if span.attr and span.attr.attributes then
    author = span.attr.attributes["author"]
  end

  if author and author ~= "" then
    return "[" .. author .. "] " .. comment_text
  end

  return comment_text
end

--
-- @brief Extract comments implemented in headers
--
function Header(el)
  local comment = nil
  local non_comment_content = {}

  for _, data in ipairs(el.content) do
    if data.t == "Span" and pandoc.List(data.attr.classes):includes("comment-start") then
      comment = format_comment_with_author(data)
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

--
-- @brief Extract comments implemented in paragraphs
--
function Para(el)
  local new_inlines = {}
  local pending_comment = nil

  for _, inline in ipairs(el.content) do
    if inline.t == "Span" and inline.attr and inline.attr.classes then
      local classes = pandoc.List(inline.attr.classes)

      if classes:includes("comment-start") then
        pending_comment = format_comment_with_author(inline)

      elseif classes:includes("comment-end") then
      else
        table.insert(new_inlines, inline)
      end

    else
      table.insert(new_inlines, inline)

      if pending_comment then
        table.insert(new_inlines, pandoc.RawInline("markdown", " <!-- " .. pending_comment .. " --> "))
        pending_comment = nil
      end
    end
  end

  el.content = new_inlines
  return el
end
