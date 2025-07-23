# ILMPG – InterLinkedMarkdown Page Gazer

**ILMPG** is a terminal-based viewer for **InterLinkedMarkdown (ILM)** documents. It renders ILM content as paged, ANSI-formatted output suitable for terminal display, and allows users to navigate between pages with a wide variety of link extensions, compatible with the latest ILM extension standard.

## Features

- View ILM documents, beautifully rendered in-terminal.
- Easy selection of hyperlinks on the page.
- Support for modern prompt links
- Supports standard ILM extensions from `ilmem` and similar
- Scrollable pager UI with keyboard navigation.
- Best-in-class documentation on everything ILM makes `ilmpg` a great place to learn about ILM as a whole.

ILMPG assigns each link a *unique number* (e.g. 123) and displays it as blue text in the terminal.

---

## Navigation

You can scroll and navigate with the keyboard, to see specific keybinds, see the [cheatsheet](ilmpg-install-dir/manual/cheatsheet.md)

### Extensions

Extensions are executable scripts or binaries stored here:

```path
~/.ilm/extensions/
```

Each extension reads a string from stdin (the *location*) and writes an ILM document to stdout.

#### Usage

```bash
ilmpg <extension-name> <location>
ilmpg file document.ilm
```

Extensions can be written in any language, but bash is most commonly used.

#### Requirements

- A terminal that supports ANSI escape sequences.
- To use the *gradient* theme, you need [md2ansi](https://github.com/Open-Technology-Foundation/md2ansi/) installed.

##### Installing md2ansi

The script `md2ansi` is the only real dependency of ILMPG. See it's [github page](https://github.com/Open-Technology-Foundation/) for installation instructions

It is a python script that, as the name implies, converts markdown files to nicely rendered ANSI text for the terminal. It is used in the default [theme](ilmpg-install-dir/manual/themes.md). If you *do not* wish to install `md2ansi`, you can use the *plain* theme, which has no dependencies. See [themes](ilmpg-install-dir/manual/themes.md) for more how to change themes.

---

## Installation

Clone the ILMPG repo and build it using Nim:

```bash
nim c -d:release src/ilmpg.nim
```

Then install extensions in `~/.ilm/extensions/`, or use an extension manager like [ILMEM](https://github.com/BeauConstrictor/ILMEM/).

## Design Philosophy

ILMPG is not a general-purpose web browser or file viewer. It intentionally avoids trying to support HTML, CSS, or JavaScript. Instead, it focuses solely on:

- Rendering ILM content.
- Providing consistent, pluggable extension behavior.
- Offering a clean, minimal interface in the terminal.

## Platform Notes

- Linux/Unix: Fully supported.
- Windows: Not *yet* supported.

## License

**MIT** – Use freely, modify, and share.
