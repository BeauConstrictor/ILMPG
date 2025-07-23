# Limitations of ILM

While ILM is a powerful and flexible format for building minimal, interlinked documents, it is intentionally limited in several ways. These limitations are design choices — not oversights — that reflect ILM’s goals of simplicity, transparency, and long-term accessibility.

## No Inline Images

ILM does *not* support embedded images with markdown like:

```
![alt text] (image.jpg)
```

Instead, just link to the image. This is to *reduce bandwidth usage*, and to *prevent advertising* in ILM. It also helps terminal-based viewers to see pages in exactly the same way any other viewer would.

## No Javascript

ILM is not designed for the modern web - there is no support for JavaScript, CSS, or sessions of any kind (mostly).

Extensions like `http:` and `https:` will fail intentionally, with an error message suggesting you use a proper browser like `lynx`.

This reinforces the idea that ILM is a separate space from the traditional web — a minimal hypertext world of its own.

## Extensions Must Be Installed

To view really anything, users must have the relevant extension installed.

If an extension isn't installed, then that portion of the Internet will be inaccessible.

## In Conclusion

ILM isn’t trying to be a replacement for HTML or modern web formats. It embraces its limitations in order to provide:

- Content, nothing more
- Pages that can be viewed anywhere
- An Internet where anyone can view any document, no matter how it's hosted.