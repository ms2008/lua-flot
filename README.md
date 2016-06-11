# lua-flot
Analyzer for nginx access log with embedded lua-flot

## Requirements

- **[lua-flot](http://stevedonovan.github.io/lua-flot/flot-lua.html)**
- lua-discount
- luafilesystem
- penlight

**Nginx configuation**:

```
log_format main '$time_local $status $request_time $upstream_response_time $remote_addr $upstream_addr $server_addr $host '
               '"$bytes_sent" "$request_body" "$request" "$http_referer" "$http_user_agent" "$gzip_ratio" "$http_x_forwarded_for"';
```

## Usage

```bash
Usage: ploter.lua FILE LINES_TO_SPLIT
 e.g.: ploter.lua slow_log 500

# cleanup the junk file
lua ploter.lua clean
# generating HTML(slow_request.hmtl)
lua ploter.lua base_slow.log 1000
```

![image](https://github.com/ms2008/lua-flot/raw/master/sample.png)

## License
**MIT**

