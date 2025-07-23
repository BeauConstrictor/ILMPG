# ILMPG – InterLinkedMarkdown Page Gazer

**ILMPG** is a terminal-based viewer for **InterLinkedMarkdown (ILM)** documents. It renders ILM content as paged, ANSI-formatted output suitable for terminal display, and allows users to navigate between pages with a wide variety of link extensions, compatible with the latest ILM extension standard.

---

## Features

- View ILM documents, beautifully rendered in-terminal.
- Easy selection of hyperlinks on the page.
- Support for modern prompt links
- Supports standard ILM extensions from `ilmem` and similar
- Scrollable pager UI with keyboard navigation.
- Best-in-class documentation on everything ILM makes `ilmpg` a great place to learn about ILM as a whole.

ILMPG is an entirely keyboard-based program, so you use your keys to scroll and navigate. To see specific keybinds, see the [cheatsheet](ilmpg-install-dir/manual/cheatsheet.md)

## Extensions

ILMPG uses the standard extension system introduced by ILM. This means that any extension manager will work with ILMPG, or you can just add extensions manually.

## Installation

Clone the ILMPG repo and build it using Nim:

```bash
nim c -d:release src/ilmpg.nim
```

Then install extensions in `~/.ilm/extensions/`, or use an extension manager like [ILMEM](https://github.com/BeauConstrictor/ILMEM/).

### Requirements

- A terminal that supports ANSI escape sequences.
- To use the *gradient* theme, you need [md2ansi](https://github.com/Open-Technology-Foundation/md2ansi/) installed.

#### Installing md2ansi

The script `md2ansi` is the only real dependency of ILMPG. See it's [github page](https://github.com/Open-Technology-Foundation/) for installation instructions

It is a python script that, as the name implies, converts markdown files to nicely rendered ANSI text for the terminal. It is used in the default theme. If you *do not* wish to install `md2ansi`, you can use the **plain** theme, which has no dependencies. See [themes](ilmpg-install-dir/manual/themes.md) for more how to change themes.

## Platform Notes

- Linux/Unix: Fully supported.
- Windows: Not *yet* supported.

## License

**MIT** – Use freely, modify, and share.
