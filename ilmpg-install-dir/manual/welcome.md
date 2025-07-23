# ILMPG – InterLinkedMarkdown Page Gazer

**ILMPG** is a terminal-based viewer for **InterLinkedMarkdown (ILM)** documents. It renders ILM content as paged, ANSI-formatted output suitable for terminal display, and allows users to navigate between pages with a wide variety of link extensions, compatible with the latest ILM extension standard.

## Features

- View ILM documents, beautifully rendered in-terminal.
- Easy selection of hyperlinks on the page.
- Support for modern prompt links
- Supports standard ILM extensions from `ilmem` and similar
- Scrollable pager UI with keyboard navigation.
- Best-in-class documentation on everything ILM makes `ilmpg` a great place to learn about ILM as a whole.

ILMPG is an entirely keyboard-based program, so you use your keys to scroll and navigate. To see specific keybinds, see the [cheatsheet](ilmpg: cheatsheet)

---

## Manual

This manual features extensive documentation, so to find what you're looking for, you may want to use the [index](ilmpg: index).
To get to any manual page directly, enter

```bash
ilmpg --manual <page-name>
```

You can see the page name at the bottom of your screen.
If you are coming from another ILM viewer and you are more comfortable reading with that program initially, then you can access this manual from any viewer using the `ilmpg` extension.

### Extensions

ILMPG uses the standard extension system introduced by ILM. This means that any extension manager will work with ILMPG, or you can just add extensions manually.

#### Usage

```bash
ilmpg <extension-name> <location>
ilmpg file document.ilm
```

Extensions can be written in any language, but bash is most commonly used.

#### Requirements

- A terminal that supports ANSI escape sequences.
- To use the *gradient* theme, you need [md2ansi](http: https://raw.githubusercontent.com/Open-Technology-Foundation/md2ansi/refs/heads/main/README.md) installed.

## Design Philosophy

ILMPG aims to be the most complete implementation of the ILM standard, while also extending its philosophy to most viewer-specific aspects that the standard doesn't explicitly mention.

## Platform Notes

- Linux/Unix: Fully supported.
- Windows: Not *yet* supported.

## License

**MIT** – Use freely, modify, and share.
