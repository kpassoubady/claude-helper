Convert the given markdown file to WhatsApp-compatible formatting. Read the file, apply the transformations below, and output the converted text so it can be copied into WhatsApp.

## WhatsApp supported formatting (reference)

Core formatting symbols:
- **Bold**: `*text*` — asterisk on both sides, no spaces between symbol and text
- **Italic**: `_text_` — underscore on both sides, no spaces between symbol and text
- **Strikethrough**: `~text~` — tilde on both sides, no spaces between symbol and text
- **Monospace**: `` ```text``` `` — three backticks on both sides for block monospace
- **Inline code**: `` `text` `` — single backtick on both sides

Advanced list and block formatting:
- **Bulleted list**: Start a line with `-` or `*` followed by a single space
- **Numbered list**: Start a line with one or two digits, a period, and a space (e.g., `1. `)
- **Block quote**: Start a line with `>` followed by a space

Combining styles:
- Bold + Italic: `*_text_*` — nest underscore inside asterisks
- Monospace cannot be combined with other styles

Critical rule — no spaces:
- There must be NO spaces between the formatting symbols and the text
- `* Bold *` will NOT work — must be `*Bold*`

## Conversion rules from standard markdown

Apply these transformations:

1. **Headers** (`#`, `##`, `###`, etc.) → Convert to `*bold text*` on its own line, followed by a blank line
2. **Bold** (`**text**` or `__text__`) → `*text*`
3. **Italic** (markdown `_text_`) → `_text_` (keep as-is, WhatsApp supports this)
4. **Bold+Italic** (`***text***`) → `*_text_*`
5. **Links** (`[text](url)`) → `text (url)` or `text - url`
6. **Images** (`![alt](url)`) → Remove or replace with `[Image: alt]`
7. **Code blocks** (triple backticks) → Keep as `` ```code``` `` (WhatsApp renders monospace)
8. **Inline code** (single backticks) → Keep as `` `code` ``
9. **Horizontal rules** (`---`, `***`) → Replace with `———`
10. **Blockquotes** (`> text`) → Keep as `> text` (WhatsApp supports this natively)
11. **Tables** → Convert to a readable plain-text layout
12. **HTML tags** → Strip or convert to plain text equivalent
13. **Bullet lists** using markdown `*` as marker → Keep as `- item` to avoid confusion with bold markers in the output

## Important notes

- If the file already uses WhatsApp-style `*...*` for bold (common in Tamil/regional language messages), preserve it as-is
- Ensure no spaces exist between formatting symbols and text in the output
- Preserve all line breaks and paragraph spacing — WhatsApp respects these
- Do NOT add any extra formatting or commentary — output only the converted message text
- Output the final result inside a single code block so the user can copy it easily

## Input

$ARGUMENTS
