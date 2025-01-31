# pandoc-comment-extractor

A Pandoc Lua filter for embedding and extracting comments between Markdown and DOCX.

## 🌱 Overview

This repository contains two Pandoc Lua filters for handling comments during Markdown ↔ DOCX conversions:

1. `md2docx_add_comment.lua`
   - Embeds HTML-style comments (`<!-- comment -->`) from Markdown into DOCX as document comments.
2. `docx2md_add_comment.lua`
   - Extracts comments from DOCX headers and converts them back into Markdown comments.

These filters are useful for tracking metadata across conversions.

---

## 🚀 Usage

### Markdown → DOCX (`md2docx_add_comment.lua`)

Use this script to embed comments into DOCX headers.

```sh
$ pandoc input.md -o output.docx --lua-filter=md2docx_add_comment.lua
```

#### Example

**Markdown Input:**

```md
<!-- COMMENT EXAMPLE -->
## Section 1
```

**DOCX Output:**

- The header "Feature Specification" will have a comment attached: `COMMENT EXAMPLE`.

---

### DOCX → Markdown (`docx2md_add_comment.lua`)

Use this script to extract comments from DOCX and restore them as Markdown comments.\
⚠️ **Note:** Use the `--track-changes=all` option for extracting DOCX comments.

```sh
$ pandoc output.docx -t gfm -o output.md --track-changes=all --lua-filter=docx2md_add_comment.lua
```

#### Example

**DOCX Input:**

- A document with a header **"Feature Specification"** containing a comment: `COMMENT EXAMPLE`.

**Markdown Output:**

```md
<!-- COMMENT EXAMPLE -->
## Section 1
```

---

## Installation

Clone this repository and use the Lua filters with Pandoc:

```sh
$ git clone https://github.com/yourusername/pandoc-comment-extractor.git
$ cd pandoc-comment-extractor
$ pandoc input.md -o output.docx --lua-filter=md2docx_add_comment.lua
$ pandoc output.docx -t gfm -o output.md --track-changes=all --lua-filter=docx2md_add_comment.lua
```


