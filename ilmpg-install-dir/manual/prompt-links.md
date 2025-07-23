# Prompt (aka. ???) Links

Prompt links are a simple way to ask the user for input when clicking a link in ILM.

Prompt links come in handy when a page needs some way to allow a user to enter some information. Before prompt links, you would have to tell the user to navigate to a specific link, with some text typed at the end, and then navigate back - not great UX. To fix this, prompt links were added to the ILM standard.

Now, you can automate this process: a user can click on a link, and their viewer will ask them for some text to insert into the link before proceeding.

The rest of this page focuses more on the technical details behind these links. If you just want to see one in action, here you go:

[Click me](echo: You typed '???' - Nice work!)

## Usage

If you want to add a prompt link to a page, it's very simple, just replace the part of the link that will change with three question marks: `???`. Here is an example:

```ilm
(http: example.com/search/???)
or, (http: example.com/search?q=???)
```

As you can see, prompt links can come in handy in a lot of cases, you can make a search engine for ILM pages, which could search across multiple protocols in one place, you could allow users to sign up for a mailing list, add a comment section to your blog - beneath the like button that you could add with normal links, and so on.

## Implementation Details

- That prompt links can contain multiple `???` sections, but users should only be prompted for text once, and that same text will be inserted into each `???` section.

- You cannot use `???` sections in the extension of a link, for example, `(???:test)` would attempt to use `???` as the actual extension of the link, and your viewer should make no attempt to change the extension.
