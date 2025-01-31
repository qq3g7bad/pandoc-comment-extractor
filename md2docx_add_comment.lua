--
-- @file    md2docx_add_tag_comment.lua
-- @brief   pandoc-comment-extractor
-- @details
--
-- ## Usage
--
-- * Use this script as a Pandoc lua filter with the following command:
--
-- ```sh
-- pandoc convert_target.md -o result.docx --lua-filter=md2docx_add_tag_comment.lua
-- ```
--

local comment_id = 1          -- This is needed for opening the output docx file in LibreOffice Writer
local extracted_comment = nil

--
-- @brief Get time for comments
--
local function format_iso8601()
  local now = os.time()
  return os.date("%Y-%m-%dT%H:%M:%S", now)
end

--
-- @brief Extract tag data from the comment line immediately before a header
--
function RawBlock(el)
  if el.format == "html" then
    local comment = el.text:match("^<!%-%- *(.-) *%-%->$")
    if comment then
      extracted_comment = {
        text = comment,
        id = comment_id
      }
      comment_id = comment_id + 1
      return {}
    end
  end
end

--
-- @brief Extract header titles and implement with comment information
--
function Header(el)
  if extracted_comment then
    local comment_span = pandoc.Span(
      { pandoc.Str(extracted_comment.text) },
      { ["class"] = "comment-start", ["id"] = extracted_comment.id, ["author"] = "shtracer", ["date"] = format_iso8601() }
    )
    local comment_end = pandoc.Span(
      {},
      { ["class"] = "comment-end", ["id"] = extracted_comment.id }
    )

    -- add comment as comment span
    table.insert(el.content, 1, comment_span)
    table.insert(el.content, comment_end)

    extracted_comment = nil
  end
  return el
end
