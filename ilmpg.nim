import std/osproc, std/streams, std/terminal, std/strutils, std/os,
       std/sets, std/random, std/tables, std/cmdline, std/sequtils
import regex

randomize()

type
  pagerMode = enum
    pmNormal, pmGotoLink, pmPeekLink

const
  extensionDir = getHomeDir() & ".ilm/extensions/"
  ansiEscape = re2"\x1b\[[0-9;]*m"
  linkPattern = re2"\[([^\]]+)\]\(([^)]+)\)"

  yPadding = 10
  maxWidth = 90

var globalIlmExtension: string
if paramCount() > 0:
  globalIlmExtension = paramStr(1)

proc xPadding(cols: int): int =
  if cols < maxWidth div 2:
    return 0
  if cols < maxWidth + 2:
    return 2
  else:
    return (cols - maxWidth) div 2

proc md2ansi(md: string): string =
  let (cols, _) = terminalSize()

  const p = "/usr/local/bin/md2ansi"
  let prc = startProcess(p, ".", 
    ["--no-links", "--width", $(cols - xPadding(cols)*2)])
  prc.inputStream.writeLine(md)
  prc.inputStream.flush()
  prc.inputStream.close()
  return prc.outputStream.readAll()

var linkMap: Table[int, string]
var usedIds = initHashSet[int]()

proc getUniqueId(): int =
  var id: int
  var idstried = 0
  while true:
    if idstried > 1000:
      echo "\e[2J\e[H" # clear
      echo "Link cache cleared.\n"
      echo md2ansi("The session has encountered more than 1000 hyperlinks, if" &
      " you go back too many pages, then some links will now lead to different" &
      " places. To fix this, just restart ilmpg.")
      stdout.write "Press any key. [ ]\b\b"
      discard getch()
      linkMap = initTable[int, string]()
      usedIds = initHashSet[int]()

    id = rand(1..999)
    if id notin usedIds:
      usedIds.incl(id)
      break
    else:
      idstried += 1
  return id


proc numberLinks(line: string): string =
  let cleanLine = line.replace(ansiEscape, "")

  var m = RegexMatch2()

  if cleanLine.find(linkPattern, m):
    let txt = cleanLine[m.group(0)]
    let linkLocation = cleanLine[m.group(1)]
    let linkId = getUniqueId()

    linkMap[linkId] = linkLocation

    result = line.replace(
      "[" & txt & "](" & linkLocation & ")",
      "\e[34m\e[4m(" & ($linkId).align(3, '0') & ") " & txt & "\e[0m\e[38;5;7m")
  else:
    result = line


proc fetch(rawLinkLocation: string, ilmExtension=globalIlmExtension): string =

  var linkLocation = rawLinkLocation
  if "???" in rawLinkLocation:
    stdout.write "> "
    let input = stdin.readLine()
    linkLocation = rawLinkLocation.replace("???", input)

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
  let ansiWithoutLinks = md2ansi(md)
  var ansiLines: seq[string]

  for i in 1..yPadding:
    ansiLines.add("")

  for line in ansiWithoutLinks.split("\n"):
    ansiLines.add(numberLinks(line))
  let ansi = ansiLines.join("\n")

  return ansi

proc startPager(ansi: string, location: string, ilmext: string) =
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
          echo "reload\nLoading..."
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
          echo "Loading..."
          let linkData = linkMap[id].split(": ")
          if  linkData.len < 2:
            startPager("The link is invalid.", "LINK EXT ABSENT", "ERROR")
          else:
            let ilmExtension = linkData[0]
            let newLinkLocation = linkData[1..^1].join(":")
            let content = fetch(newLinkLocation, ilmExtension)
            let ansi = getPage(content)
            startPager(ansi, newLinkLocation, ilmExtension)

const usage = """Usage: ilmpg EXTENSION [OPTION]... DOMAIN [PATH]... [--KEY [VALUE]]...
Try 'ilmpg --manual welcome' for more information"""

const version = """ilmpg (Interlinked-Markdown Page Gazer) 1.0.0
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
  elif paramStr(1) == "--manual"  or paramStr(1) == "-m" and paramCount() > 1:
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