# pandoc-comment-extractor

A Pandoc Lua filter for embedding and extracting comments between Markdown and DOCX.

## 🌱 Overview

This repository contains two Pandoc Lua filters for handling comments during Markdown ↔ DOCX conversions:

1. `md2docx_add_comment.lua`
   - Embeds HTML-style comments (`<!-- comment -->`) from Markdown into DOCX as document comments.
   - Supports customizable author names via environment variables.
2. `docx2md_add_comment.lua`
   - Extracts comments from DOCX headers and converts them back into Markdown comments.
   - Preserves author information from DOCX comments.

These filters are useful for tracking metadata and authorship across conversions.

---

## 🚀 Usage

### 🔴 Markdown → DOCX (`md2docx_add_comment.lua`)

Use this script to embed comments into DOCX headers.

```sh
$ pandoc input.md -o output.docx --lua-filter=md2docx_add_comment.lua
```

#### Customizing Author Name

You can customize the comment author by setting the `PANDOC_COMMENT_AUTHOR` environment variable:

```sh
$ export PANDOC_COMMENT_AUTHOR="qq3g7bad"
$ pandoc input.md -o output.docx --lua-filter=md2docx_add_comment.lua
```

**Default author**: If the environment variable is not set, it defaults to `"Unknown Author"`.

#### Example

**Markdown Input:**

```md
<!-- COMMENT EXAMPLE -->
## Section 1
```

**DOCX Output:**

- The header "Section 1" will have a comment attached: `COMMENT EXAMPLE` (authored by the value of `PANDOC_COMMENT_AUTHOR` or `"Unknown Author"`).

---

### 🔵 DOCX → Markdown (`docx2md_add_comment.lua`)

Use this script to extract comments from DOCX and restore them as Markdown comments.\

> [!NOTE]
> Use the `--track-changes=all` option for extracting DOCX comments.

```sh
$ pandoc input.docx -t gfm -o output.md --track-changes=all --lua-filter=docx2md_add_comment.lua
```

#### Author Information

This filter preserves author information from DOCX comments. If a comment has an author, it will be included in the output as `[author] comment_text`.

#### Example

**DOCX Input:**

- A document with a header **"Section 1"** containing a comment: `COMMENT EXAMPLE` (authored by `qq3g7bad`).

**Markdown Output:**

```md
<!-- [qq3g7bad] COMMENT EXAMPLE -->
## Section 1
```

If the author is unknown or not set, it will appear as `[Unknown Author]`.

---

## 🟡 Installation

Clone this repository and use the Lua filters with Pandoc:

```sh
$ git clone https://github.com/qq3g7bad/pandoc-comment-extractor.git
$ cd pandoc-comment-extractor
$ pandoc input.md -o output.docx --lua-filter=md2docx_add_comment.lua
$ pandoc input.docx -t gfm -o output.md --track-changes=all --lua-filter=docx2md_add_comment.lua
```


