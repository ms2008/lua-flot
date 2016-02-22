# lua-flot
Analyzer for nginx access log with embedded lua-flot

# Requirements

- lua-discount
- luafilesystem
- penlight

# Usage

```
Usage: ploter.lua FILE LINES_TO_SPLIT
 e.g.: ploter.lua slow_log 500

lua ploter.lua base_slow.log 1000
```
