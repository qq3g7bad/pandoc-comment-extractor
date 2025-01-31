--
-- @file    docx2md_add_tag_comment.lua
-- @brief   pandoc-comment-extractor
-- @details
--
-- ## Usage
--
-- * Use this script as a Pandoc lua filter with the following command:
-- * NOTE: Use `--track-changes=all` option for extracting docx comments.
--
-- ```sh
-- pandoc output.docx -t gfm -o output.md --track-changes=all --lua-filter=./docx2md_add_tag_comment.lua
-- ```
--


--
-- @brief Extract tag data implemented in headers
--
function Header(el)

  local section_title = ""
  local comment = nil
  for _, data in ipairs(el.content) do

    -- extract comment text by searching a comment-start tag
    if data.attr and data.attr.classes then
      for i, class in ipairs(data.attr.classes) do
        if class == "comment-start" then
          comment = data.content[i].text
        end
      end
    end

    -- extract comment text
    if data.text then
      section_title = section_title .. " " .. data.text
    end
  end
  section_title = string.rep("#", el.level) .. section_title

  if comment then
    return {
      pandoc.RawBlock("markdown", "<!-- " .. comment .. " -->\n" .. section_title)
    }
  end
  return el
end

