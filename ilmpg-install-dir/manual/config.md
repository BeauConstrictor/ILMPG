# ILMPG Configuration

ILMPG can be customized using a JSON config file located at:

```path
~/.ilm/ilmpg/config.json
```

## Supported Keys

- `theme` (string):  
  The name of the theme binary to use for rendering Markdown.  
  *Default*: `"plain"`

- `y-padding` (integer):  
  How many empty lines to insert above and below the rendered content.  
  *Default*: `10`

- `max-width` (integer):  
  Maximum content width in characters. Used for centering content.  
  *Default*: `66`.  
  Use `-1` to disable horizontal centering.

## Example

```js
{
  "theme": "dark",
  "y-padding": 8,
  "max-width": 72
}
```

The theme executable must exist at:

```path
~/.ilm/ilmpg/themes/theme-name
```

Themes are discussed in [Theming](ilmpg: themes).
