# ILMPG Link System

ILMPG recognizes Markdown-style links:

```ilm
[Label] (ext: location)
```

**NOTE**: some ILM viewers will render links, even inside of code blocks. So for syntax examples of links throughout this manual, a space is placed like this: `] (`. In reality, it should be like this: `](`. Keep than in mind when reading the manual.

## How Links Work

- `ext:` is the name of the extension (such as `ilmpg`, `gemini`, etc).
- `location` is the page or target path.
- Links are parsed and numbered in display order.
- When a link is selected, ILMPG calls the appropriate extension binary with the location.

## Prompt Links

If a link contains `???`, the user is prompted to enter a value.

```ilm
[Search] (gemini: gemini://example.com/search/???)
```

ILMPG replaces `???` with the user’s input. This input is encoded by a special mode for each extension just for this purpose.

See [Prompt Links](ilmpg: prompt-links) for details.

## Example

```ilm
[Home] (ilmpg: welcome)
[Docs] (ilmpg: about-ilm)
[Search] (gemini: gemini://example.org/search/???)
```

These will be turned into numbered references like:

```output
(001) Home
(002) Docs
(003) Search
```

Which the user can jump to via `g` + number + `Enter`.
