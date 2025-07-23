# Writing ILMPG Extensions

An extension is a **binary** that accepts a string on stdin and outputs Markdown to stdout.

## File Location

Extensions must live in:

```path
~/.ilm/extensions/
```

## File Naming

- Base binary:  
  `your-extension`

- Encoder binary (optional):  
  `your-extension-encoder`

## Execution Flow

1. ILMPG detects a link:  
   `[Example] (your-extension: something)`

2. It runs:  
   `~/.ilm/extensions/your-extension`
   And writes `something` to stdin.

3. The extension returns Markdown on stdout.

## Encoder

If the link contains ``???``, ILMPG will prompt the user for input, then run the encoder binary with that input to encode it before substitution.

## Minimal Example (Shell)

```bash
#!/bin/bash
case "$1" in
  welcome) echo "# Welcome Page\nThis is an extension page." ;;
  *) echo "# Error\nUnknown page." ;;
esac
```

Save to `~/.ilm/extensions/myext`, and then add permissions:

```bash

chmod +x ~/.ilm/extensions/myext
```

Now this link works:

```ilm
[Hello] (myext: welcome)
```
