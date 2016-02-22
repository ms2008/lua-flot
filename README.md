# lua-flot
Analyzer for nginx access log with embedded lua-flot

# Requirements

- lua-discount
- luafilesystem
- penlight

# Usage

```bash
Usage: ploter.lua FILE LINES_TO_SPLIT
 e.g.: ploter.lua slow_log 500

# cleanup the junk file
lua ploter.lua clean
# generating HTML(slow_request.hmtl)
lua ploter.lua base_slow.log 1000
```

![image](https://github.com/ms2008/lua-flot/raw/master/sample.png)
