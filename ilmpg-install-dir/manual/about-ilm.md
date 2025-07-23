# InterLinkedMarkdown

**InterLinkedMarkdown (ILM)** is a minimalist extension of the Markdown standard. It allows you to create simple, hyperlinked pages that can reference content across many different protocols — including HTTP, Gemini, IPFS, local files, and more.

ILM documents are readable in plain-text, render beautifully in terminal-based viewers, and can link to practically anything via modular handlers called *extensions*.

---

## Why ILM?

Many people are frustrated with the state of the modern web. Alternative protocols like Gemini, IPFS, and other systems have emerged to solve these problems — but most of them are isolated from one another.

Often, these projects solve real problems with the web, but they all shoot themselves in the foot in at least one way: they all compete not only against the web, *but against each other*. ILM aims to unite all of these protocols by allowing pages written for one alternative-web to integrate seamlessly with any other.

ILM strives to make documents readable by anyone (or anything!), inter-linkable, and able to link outward to other document formats, besides ILM - in an ideal world this would not be necessary, but that's just how it is.

---

## What is ILM?

ILM is not a large modification to Markdown — only one change was made: *link destination syntax*.
Instead of just a URL or file path, links in ILM include the extension name, which tells the viewer which handler to invoke for that link.
This means ILM is fully backward-compatible with plain Markdown in most cases.

### ILM Link Format

In standard Markdown, a link looks like this:

```markdown
[Example] (https://example.com)
```

In ILM, the link destination is split into two parts: the extension and the location. This allows the viewer to delegate how to resolve the link.

```ilm
[Example] (extension: location)
```

**NOTE**: For both of the above examples, a space was added between `](` to prevent the above links actually being rendered as links in some viewers, ignore that space.

#### Example

[Link](echo: Congrats, you just followed your first ILM link!)

### Technical Details

Markdown is not a well-standardised language. ILM strives to be consistent, but for that to be possible, it needs to be built on its own standard base. That's why ILM is *technically* based on [CommonMark](http: https://raw.githubusercontent.com/commonmark/commonmark-spec/refs/heads/master/README.md).

## Extensions

Extensions are small *executable programs* that determine how to fetch or generate the content for a link.
ILM viewers call these extensions dynamically when a link is selected.

### Examples

- http: Fetch a document with HTTP(S)
- gemini: Fetch an ILM document via the Gemini protocol
- ipfs: Fetch a document from IPFS
- file: Load a local ILM file
- echo: Return a fixed message (useful for testing)
- gopher: Fetch an ILM document via Gopher

Some extensions also act as translators, like `gemtext` or `gophertext`. Both of these extensions can be used to link to documents that are not served in ILM format. Translators are needed to help ILM meet its goal of linking every document in the world during its early days, before it gets widespread adoption.

Finally, some extensions act like little apps that live inside your ILM viewer. These are obviously not used to link documents together, but to add niceties to an ILM viewer, while keeping it lightweight. The most popular example is the `bookmarks` extension, which does exactly what it says on the tin.

### How They Work

1. The viewer passes the link’s location to the extension via standard input.
2. The extension echoes ILM-formatted Markdown to standard output.

This makes the extension system language-agnostic — they can be written in Bash, Python, C, or anything else.

#### Standard System

Extensions are standardised by ILM, so that extensions can be installed with a dedicated extension manager, and be accessible to any program that needs access to extensions to make requests - the most common example being an ILM viewer.

On POSIX systems, extensions are stored in:

```path
~/.ilm/extensions/
```

They must be executable and named after the extension they implement. For example, the url extension would be:

```path
~/.ilm/extensions/url
```

Unfortunately, ILM viewers are not yet fully standardised on Windows, and usually include bespoke extension systems - a small issue, but either way, standardisation for this is in the works.

## Design Philosophy

ILM has a few guiding principles:

- **Simplicity**: It should be *easy* to *write*, *read*, and *parse* ILM documents.
- **Plaintext**: ILM should be *viewable anywhere*, regardless of dedicated ILM support, to keep the world's documents accessible.
- **Accessible** - ILM should be designed so that *documents naturally provide wide accessibility* - both to *people* and *programs*.
- **Linking**: ILM documents should have the capability to *link to absolutely any other document* in existence, in one way or another, be it the author serving those documents in ILM, extensions translating them on the fly, or a central source archiving them.

## Getting Started

Hopefully, you now have a strong enough understanding of ILM to get started browsing documents. Currently, the most feature complete ILM viewer is a program called ILMPG, which requires you to install extensions separately using an extension manager such as [ILMEM](http: https://raw.githubusercontent.com/BeauConstrictor/ILMEM/refs/heads/main/README.md). With both of these programs installed, you will have unfettered access to the majority of the world's documents - one day, once ILM sees more adoption `:(`.
