# ==============================================================================
# ilmpg (Interlinked-Markdown Page Gazer)
#
# Author: BeauConstrictor
# License: MIT
#
# Description:
# This program is a terminal-based pager for viewing interlinked Markdown
# documents with rich ANSI styling and interactive hyperlink navigation.
#
# Features:
# - Renders Markdown using customizable external theming binaries.
# - Detects and replaces Markdown-style links with numbered references.
# - Allows link navigation by ID, with optional text encoding.
# - Supports extensions for dynamic link resolution.
# - Configurable appearance via JSON settings.
#
# Usage:
#   ilmpg EXTENSION [OPTION]... DOMAIN [PATH]... [--KEY [VALUE]]...
#   Try 'ilmpg --manual welcome' for detailed usage.
#
# Dependencies:
#   - External binaries located in ~/.ilm/extensions/ & ~/.ilm/ilmpg/themes/
#   - Config file located at ~/.ilm/ilmpg/config.json
#   - Terminal with ANSI support
#
# Notes:
# - Link caching is used to avoid ID conflicts and support back navigation.
# - Uses an alternate screen buffer during pager mode.
# - Designed for use in Markdown-based hypertext systems.
#
# Todos:
# TODO: implement pmPeekLink
#
# Bugs:
# TODO: you can't go to links with 4 digit IDs (or more)
# TODO: headings in gradient theme do not wrap
# TODO: get rid of all the iteration in getPage
# TODO: some escape sequences for input cause weird behaviour - look into this
#
# WIP Windows Support:
# TODO: alternate extension system on Windows
#
# ==============================================================================

import std/osproc, std/streams, std/terminal, std/strutils, std/os, std/random,
       std/tables, std/cmdline, std/exitprocs, std/json
import regex

randomize()


proc supportsAnsi(): bool =
  result = isatty(stdout)
  result = result and getEnv("TERM") != ""
  result = result and not getEnv("TERM").startsWith("dumb")

if not supportsAnsi():
  when defined(windows):
    echo "Your terminal doesn't support ANSI, a requirement for this program" &
         " to operate. I recommend Windows Terminal, which is available from" &
         " the Microsoft Store."
  when not defined(windows):
    echo " Your terminal doesn't support ANSI, a requirement for this program" &
         " to operate. I recommend Kitty."

  quit 1


type
  pagerMode = enum
    pmNormal, pmGotoLink, pmPeekLink

const
  extensionDir = getHomeDir() & ".ilm/extensions/"
  ansiEscape = re2"\x1b\[[0-9;]*m"
  linkPattern = re2"\[([^\]]+)\]\(([^)]+)\)"

  configPath = getHomeDir() & ".ilm/ilmpg/config.json"

let
  jsonNode = parseJson(readFile(configPath))

proc getSettingStr(name: string, default: string): string =
  try:
    return jsonNode[name].getStr()
  except:
    return default

proc getSettingInt(name: string, default: int): int =
  try:
    return jsonNode[name].getInt()
  except:
    return default

let
  themeName = getSettingStr("theme", "plain")
  yPadding = getSettingInt("y-padding", 10)
  maxWidth = getSettingInt("max-width", 66)

var globalIlmExtension: string
if paramCount() > 0:
  globalIlmExtension = paramStr(1)

proc xPadding(cols: int): int =
  if maxWidth == -1:
    return 1

  if cols < maxWidth div 2:
    return 0
  if cols < maxWidth + 2:
    return 2
  else:
    return (cols - maxWidth) div 2

proc restoreTerminal() =
  echo "\e[0m\e[?25h\e[2J\e[H\e[?1049l"
  stdout.flushFile()

proc theme(md: string): string =
  let (cols, _) = terminalSize()

  let p = getHomeDir() & ".ilm/ilmpg/themes/" & themeName
  let prc = startProcess(p, ".", [$(cols - xPadding(cols)*2)])
  prc.inputStream.writeLine(md)
  prc.inputStream.flush()
  prc.inputStream.close()
  return prc.outputStream.readAll()

var linkMap: Table[int, string]
var linkCounter = 0

proc getUniqueId(): int =
  linkCounter += 1
  return linkCounter


proc numberLinks(line: string): string =
  var outLine = line
  var depth = 0
  while true:
    if depth == 999:
      break

    let cleanLine = outLine.replace(ansiEscape, "")
    var m = RegexMatch2()
    if cleanLine.find(linkPattern, m):
      let txt = cleanLine[m.group(0)]
      let loc = cleanLine[m.group(1)]
      let linkId = getUniqueId()
      linkMap[linkId] = loc

      outLine = outLine.replace(
        "[" & txt & "](" & loc & ")",
        "\e[34m(" & ($linkId).align(3, '0') & ") " & txt & "\e[0m\e[38;5;7m")
      inc depth
    else:
      break

  return outLine


proc encodeText(text: string, ilmExtension: string): string =
  let bin = extensionDir & ilmExtension & "-encoder"
  if not fileExists(bin):
    return text
  let prc = startProcess(bin)
  prc.inputStream.write(text)
  prc.inputStream.flush()
  prc.inputStream.close()
  return prc.outputStream.readAll()


proc fetch(rawLinkLocation: string, ilmExtension=globalIlmExtension): string =
  var linkLocation = rawLinkLocation
  if "???" in rawLinkLocation:
    stdout.write rawLinkLocation & " -> "
    let input = stdin.readLine()
    let encoded = encodeText(input, ilmExtension)
    linkLocation = rawLinkLocation.replace("???", encoded)

  echo "Loading..."

  let bin = extensionDir & ilmExtension
  if not fileExists(bin):
    return "Extension '" & ilmExtension & "' is not installed."
  let prc = startProcess(bin)
  prc.inputStream.write(linkLocation)
  prc.inputStream.flush()
  prc.inputStream.close()
  return prc.outputStream.readAll()

proc showPage(lines: seq[string], title: string, offset: int, rows: int) =
  let offsetLines = lines[offset .. ^1]
  let (cols, _) = terminalSize()

  echo "\e[2J\e[H\e[0m\e[38;5;7m" # clear & grey text
  var linesEchoed = 0
  for line in offsetLines[0..<min(rows-3, offsetLines.len)]:
    echo ' '.repeat(xPadding(cols)) & line
    linesEchoed += 1
  
  stdout.write "\n".repeat(rows - linesEchoed - 2)

  echo "\e[0m" & title
  stdout.write "q for quit, h for help -> "

proc getPage(md: string): string =
  let ansi = numberLinks(theme(md))
  var ansiLines: seq[string]

  for i in 1..yPadding:
    ansiLines.add("")

  for line in ansi.split("\n"):
    ansiLines.add(line)

  return ansiLines.join("\n")

proc startPager(ansi: string, location: string, ilmext: string) =
  stdout.write "\e[?1049h"
  addExitProc restoreTerminal
  
  let title = ilmext.toUpper() & ": " & location
  let (_, rows) = terminalSize()

  var offset = 0
  var lines = ansi.split("\n")
  var mode = pmNormal

  while true:
    showPage(lines, title, offset, rows)
    if mode == pmNormal:
      case getch()
        of 'b':
          echo "\e[0m"
          break
        of 'q', '\x03':
          echo "\e[0m"
          quit 0
        of 'k':
          offset -= 1
        of 'j':
          offset += 1
        of 'r':
          echo "reload\n"
          let md = fetch(location, ilmext)
          let ansi = getPage(md)
          startPager(ansi, location, ilmext)
          break
        of 'h':
          let md = fetch("cheatsheet", "ilmpg")
          let ansi = getPage(md)
          startPager(ansi, "cheatsheet", "ilmpg")
        of 'g':
          mode = pmGotoLink
        of '\x1B':
          discard getch() # [
          case getch().int:
            of 65:
              offset -= 1
            of 66:
              offset += 1
            else:
              discard
        else:
          discard
        
      if offset < 0:
        offset = 0
      elif offset > lines.len - 3:
        offset = lines.len - 3

    elif mode == pmGotoLink:
      mode = pmNormal
      stdout.write "goto "
      let choice = stdin.readLine()

      if choice == "":
        discard
      elif choice.len > 3 and ": " in choice:
        let ext = choice.split(": ")[0]
        let loc = choice[ext.len+2..^1]
        let md = fetch(loc, ext)
        let ansi = getPage(md)
        startPager(ansi, loc, ext)
      elif choice.len > 3:
        let md = fetch(choice)
        let ansi = getPage(md)
        startPager(ansi, choice, globalIlmExtension)
      else:
        var id: int
        try:
          id = choice.parseInt()
        except:
          discard
        if id notin linkMap:
          echo "Link not found on page!"
          discard getch()
        else:
          let linkData = linkMap[id].replace("\n", " ").split(": ", 1)
          if  linkData.len < 2:
            let md = fetch("The link you selected is missing an extension. This is likely due to the page being designed for a traditional markdown viewer.", "error")
            let ansi = getPage(md)
            startPager(ansi, "Invalid Link", "error")
          else:
            let ilmExtension = linkData[0]
            let newLinkLocation = linkData[1..^1].join(":")
            let content = fetch(newLinkLocation, ilmExtension)
            let ansi = getPage(content)
            startPager(ansi, newLinkLocation, ilmExtension)

const usage = """Usage: ilmpg [OPTION] EXTENSION LOCATION
Try 'ilmpg --manual welcome' for more information"""

const version = """ilmpg (Interlinked-Markdxown Page Gazer) 1.0.0
This project is licensed under the terms of the MIT license."""

when isMainModule:
  if paramCount() == 0:
    echo usage
  elif paramStr(1) == "--version" or paramStr(1) == "-v":
    echo version
  elif paramStr(1) == "--help" or paramStr(1) == "-h":
    let md = fetch("cheatsheet", "ilmpg")
    let ansi = getPage(md)
    startPager(ansi, "cheatsheet", "ilmpg")
  elif (paramStr(1) == "--manual" or paramStr(1) == "-m") and paramCount() > 1:    
    globalIlmExtension = "ilmpg"
    let location = commandLineParams()[1..^1].join(" ")
    let md = fetch(location, globalIlmExtension)
    let ansi = getPage(md)
    startPager(ansi, location, globalIlmExtension)
  else:
    if paramCount() < 2:
      echo usage
      quit 0
    
    let location = commandLineParams()[1..^1].join(" ")
    let md = fetch(location)
    let ansi = getPage(md)
    startPager(ansi, location, globalIlmExtension)