# ILMPG Themes

ILMPG uses external **theme binaries** to render Markdown into styled ANSI text for terminal display.

## File Location

Themes must be executable binaries placed in:

```path
~/.ilm/ilmpg/themes/
```

## Input

When ILMPG calls a theme, it:

- Passes the **target width** (in characters) as the first argument
- Sends the **raw Markdown** via `stdin`

## Output

The theme should print **ANSI-styled** lines to `stdout`.  
This allows full control over the display formatting.

## Default Theme: `gradient`

ILMPG ships with a default theme named **`gradient`**.  
It is built on **[`md2ansi`](https://github.com/beauconstrictor/md2ansi)** and provides rich, colorful formatting with minimal dependencies.

This theme gets its name from how it renders heading levels. It uses a color gradient to differentiate different heading levels, going from yellow to green.

## Fallback Theme: `plain`

A second theme named **`plain`** is included.  
This theme simply **echoes raw Markdown**, with *no styling or transformation*.

> `plain` is useful for debugging, writing minimal extensions, or viewing content in terminals with no ANSI color support.

It requires **no external tools or libraries** — Markdown should be formatted for readability in this mode.

## Example Theme Script (Bash)

```bash
#!/bin/bash
# Bold every line (demo)
while IFS= read -r line; do
  echo "\e[1m$line\e[0m"
done
```

Make it executable:

```bash
chmod +x ~/.ilm/ilmpg/themes/mytheme
```

## Setting Your Theme

Update your config file:

```js
{
  "theme": "mytheme"
}
```

See [Config](ilmpg: config) for details on the config file location and options.

---

Using themes, you can fully customize ILMPG’s look and feel to match your terminal or aesthetic preferences.
