# pandoc-comment-extractor

**Keep your comments when converting between Markdown and Word!**

A set of Pandoc Lua filters that preserve document comments during Markdown ↔ DOCX conversions, enabling seamless collaboration between Git-based workflows and traditional document editing.

---

## 💡 Why Use This?

Ever tried to version control Word documents in Git? Or wanted to bring Word comments back into your Markdown workflow? This tool bridges that gap:

- **📝 Git-friendly Word collaboration** - Convert Word docs with comments to Markdown for version control
- **🔄 Round-trip conversion** - Preserve review comments across Markdown → Word → Markdown cycles
- **👥 Team workflows** - Accept Word edits from non-technical collaborators while keeping Git history
- **🏷️ Author tracking** - Maintain comment authorship throughout the conversion process

### Real-world use cases

- Technical writing teams using both Git and Word
- Documentation reviews where reviewers prefer Word
- Converting legacy Word documents to Markdown without losing metadata
- Collaborative editing across different toolchains

---

## ⚡ Quick Start

**1. Install**

```sh
git clone https://github.com/qq3g7bad/pandoc-comment-extractor.git
cd pandoc-comment-extractor
```

**2. Try it out - Markdown to Word**

```sh
# Create a sample Markdown file with a comment
echo '<!-- This is a review comment -->' > sample.md
echo '## Introduction' >> sample.md
echo 'This is sample text.' >> sample.md

# Convert to Word (comment becomes a Word comment)
export PANDOC_COMMENT_AUTHOR="YourName"
pandoc sample.md -o sample.docx --lua-filter=md2docx_add_comment.lua
```

**3. Try it out - Word back to Markdown**

```sh
# Convert back to Markdown (Word comment becomes HTML comment again)
pandoc sample.docx -t gfm -o result.md \
  --track-changes=all \
  --lua-filter=docx2md_add_comment.lua

cat result.md
# Output: <!-- [YourName] This is a review comment -->
#         ## Introduction
```

---

## 📦 Installation

### Prerequisites

- [Pandoc](https://pandoc.org/installing.html) 2.0 or later

### Install filters

**Option 1: Clone this repository** (Recommended)

```sh
git clone https://github.com/qq3g7bad/pandoc-comment-extractor.git
```

**Option 2: Download individual filters**

```sh
# Download the filters you need
curl -O https://raw.githubusercontent.com/qq3g7bad/pandoc-comment-extractor/main/md2docx_add_comment.lua
curl -O https://raw.githubusercontent.com/qq3g7bad/pandoc-comment-extractor/main/docx2md_add_comment.lua
```

---

## 🚀 Usage

### Overview

This repository provides two complementary filters:

| Filter | Direction | Purpose |
|--------|-----------|---------|
| `md2docx_add_comment.lua` | Markdown → DOCX | Converts HTML comments to Word comments |
| `docx2md_add_comment.lua` | DOCX → Markdown | Extracts Word comments back to HTML comments |

---

### 🔴 Markdown → DOCX

Convert Markdown with HTML comments to Word documents with tracked comments.

**Basic usage:**

```sh
pandoc input.md -o output.docx --lua-filter=md2docx_add_comment.lua
```

**Input (`input.md`):**

```markdown
<!-- TODO: Add more details here -->
## Project Overview

<!-- REVIEWER: This section needs revision -->
This is the project description.
```

**Output:** Word document with two comments:

- "TODO: Add more details here" attached to "Project Overview" heading
- "REVIEWER: This section needs revision" in the paragraph

**Specify author name:**

```sh
export PANDOC_COMMENT_AUTHOR="Alice"
pandoc input.md -o output.docx --lua-filter=md2docx_add_comment.lua
```

Comments will be attributed to "Alice" instead of the default "Unknown Author".

---

### 🔵 DOCX → Markdown

Extract Word comments back to Markdown HTML comments.

**Basic usage:**

```sh
pandoc input.docx -t gfm -o output.md \
  --track-changes=all \
  --lua-filter=docx2md_add_comment.lua
```

> **Important:** Always use `--track-changes=all` to extract comments!

**Input:** Word document with comment "Needs citation" by "Bob" on heading "Background"

**Output (`output.md`):**

```markdown
<!-- [Bob] Needs citation -->
## Background
```

**Author information:**

- If the Word comment has an author, it appears as `[AuthorName]`
- If no author is set, it appears as `[Unknown Author]`

---

## ⚙️ Configuration

### Environment Variables

| Variable | Purpose | Default |
|----------|---------|---------|
| `PANDOC_COMMENT_AUTHOR` | Sets the author name for Markdown→DOCX conversion | `"Unknown Author"` |

**Example:**

```sh
# Set for current session
export PANDOC_COMMENT_AUTHOR="qq3g7bad"

# Or set inline for a single command
PANDOC_COMMENT_AUTHOR="TeamLead" pandoc doc.md -o doc.docx --lua-filter=md2docx_add_comment.lua
```

**Add to your shell profile** (`.bashrc`, `.zshrc`, etc.):

```sh
export PANDOC_COMMENT_AUTHOR="YourGitHubUsername"
```

---

## 🤝 Contributing

Contributions are welcome! Feel free to:

- Report bugs or request features via [Issues](https://github.com/qq3g7bad/pandoc-comment-extractor/issues)
- Submit Pull Requests with improvements
- Share your use cases

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🔗 Related Projects

- [Pandoc](https://pandoc.org/) - Universal document converter
- [shtracer](https://github.com/qq3g7bad/shtracer) - POSIX shell-based requirement tracking tool (pairs well with this!)
