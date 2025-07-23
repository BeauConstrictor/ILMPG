# ILMPG (Inter-Linked Markdown Page Gazer)

A viewer for ILM pages, supporting standard extensions

Usage: ilmpg [OPTION]... EXTENSION LOCATION

## Arguments

| Argument      | Description                                   |
| ------------- | --------------------------------------------- |
| --help, -h    | Show this help message and exit               |
| --version, -v | Show version information and exit             |
| --manual, -m  | Visit a page in the manual                    |
| EXTENSION     | ILM extension to use when fetching content    |
| LOCATION      | The location to pass to the extension         |

## Example

```bash
ilmpg file README.md
```

## Notes

- You can use  `--manual` or `-m` as an alias for the `ilmpg` extension, used for viewing the manual.

## Modes

ILMPG is a modal pager, meaning keys do not always do the same thing - it depends on the currently active mode.

### Normal

In this mode, you press *single keys* to perform general actions.

| Key     | Action |
| ------- | ------ |
| q       | quit   |
| b       | back   |
| g       | goto   |
| p       | peek   |
| r       | reload |
| j/up    | down   |
| k/down  | pgup   |
| h       | help   |

### Goto

You can enter this mode by pressing `g` in normal mode. Here, you can navigate to any page.

In goto mode, you can enter one of three things:

- A link number from any page you have visited.
- A location to go to using the extension you opened ILMPG with.
- A target (`extension: location`) to visit.

### Peek

You can enter this mode by pressing `p` in normal mode. Here, you can see where links lead.

Just enter the number of a link, and it will tell you its target.
