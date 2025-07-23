# Managing Extensions

To view any page with an ILM viewer, you need an *extension*. Say you want to view a page that is hosted with the gemini protocol. You would need to install the `gemini` extension. The same goes for any type of link. In fact, you are using the `ilmpg` extension right now to view this manual!

Because ILM allows any page, hosted anywhere to link to any other page, also hosted anywhere, and no viewer can ever possibly hope to implement every protocol a file could be hosted with, extensions exist.

An ILM viewer does not need to have an extension model, but it probably should. Also, an ILM viewer can use any extension model it likes, but there is a standard system of extensions offered by the ILM spec. The advantage of this is that an extension only needs to be created once, and every viewer can support it. This means you should never be shooting yourself in the foot by picking a certain ILM viewer that doesn't have as many extensions implemented - they all have *all* the extensions!

## Where do I find Extensions?

You can find them anywhere! They are just a single file that goes in a specific folder on your computer, and your ILM viewer will recognise it. However, it is usually easier to use an extension manager. This way, if you click on a link and your viewer doesn't have an extension for it, you can just open up your extension manager, type in the link type, and it will install a trusted extension, immediately.

The most popular extension manager, and the one offered by the team behind ILM itself and ILMPG, is [ILMEM](http: https://raw.githubusercontent.com/BeauConstrictor/ILMEM/refs/heads/main/README.md). This manager is incredibly simple, but it does everything you would need, and has by far the largest pool of extensions available.

Once you have installed ILMEM, you can test it out like so:

```bash
$ ilmem list
~~ Installed extensions:
ilmpg
```

This will likely show far more extensions than just `ilmpg`, but `ilmpg` is almost certainly somewhere in the list, because you need it to view this manual.

## How do I use ILMEM?

To view an up-to-date guide on `ilmem`, just enter:

```bash
ilmem --help
```

However, here are the most basic things you can do:

- `ilmem install <extension>` - install an extension by name
- `ilmem list` - list all installed extensions
- `ilmem remove <extension>` - uninstall an extension
- `ilmem update <extension>` - update an extension to the latest version
- `ilmem run <extension> <location>` - run an extension

### ILMEM run

This command is probably the most complex one in ILMEM - it acts like an ultra lightweight ILM viewer. It doesn't render pages in any way, it doesn't have paging, it just shows you the output of an extension.
