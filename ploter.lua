----------------------------------------------------------------------------
-- Issue: ULUCU PHP Slow Request Log Analyzer
-- Copyright (C)2015 ULUCU Co.,Ltd. All Rights Reserved
-- Author: yufu.zhao <zyfu@ulucu.com> at 2016-02-19 15:00:11
----------------------------------------------------------------------------

-- 清除日志文件
local function clean()
    local del_files = os.execute("rm -rf slow_*")
    if del_files ~= 0 then
        print("exec rm command failed")
        os.exit(105)
    end
end

if arg[1] == "clean" then
    return clean()
elseif #arg ~= 2 then
    print("Usage: " .. arg[0] .. " FILE LINES_TO_SPLIT")
    print(" e.g.: " .. arg[0] .. " slow_log 500")
    os.exit(-1)
end

clean()
-- 拆分日志
local split_cmd = string.format("split -l %d -d %s slow_log_", arg[2], arg[1])
local split_rtn = os.execute(split_cmd)
if split_rtn ~= 0 then
    print("exec split command failed")
    os.exit(101)
end

-- 获取日志被拆分的个数
local split_file_count = tonumber(io.popen("ls slow_log_* | wc -l"):read("*l"))
      io.close()

if split_file_count == 0 then
    print("have no split files found")
    os.exit(102)
end

--- Example
-- split -l 500 -d base_slow.log slow
-- cp template.lua slow01.lua
-- sed -i 's/slow00/slow01/' slow01.lua
-- sed -i 's/p:add_series("Std"/-- p:add_series("Std"/' slow0*
-- lua prettify.lua slow_request lua preview

-- 生成对应的 lua-flot 文件
local flot_chunk = {}

for i=0,split_file_count-1 do
    flot_chunk[2*i+1] = string.format("cp template.lua slow_log_%02d.lua", i)
    if split_file_count == 1 then
        local sed_param = {
            [[sed -i -e '9,13d']],
            [[-e 's/arg\[1\]/"slow_log_%02d"/']],
            [[-e 's/height=200/height=600/']],
            [[-e 's/-- p:add_series("Std"/p:add_series("Std"/']],
            [[slow_log_%02d.lua]]
        }
        flot_chunk[2*i+2] = string.format(table.concat(sed_param, " "), i, i)
    else
        flot_chunk[2*i+2] = string.format([[sed -i 's/arg\[1\]/"slow_log_%02d"/' slow_log_%02d.lua]], i, i)
    end
end

local gen_flot_lua = os.execute(table.concat(flot_chunk, "\n"))
if gen_flot_lua ~= 0 then
    print("exec cp & sed command failed")
    os.exit(103)
end

-- 生成 pretty md 文件
local plot_md = {
    "",
    "##Ulucu PHP 慢请求统计",
    ""
}

for i=0,split_file_count-1 do
    if split_file_count ~= 1 then
        plot_md[#plot_md+1] = string.format("    -- slow_log_%02d\n", i)
    end
    plot_md[#plot_md+1] = string.format("@plot slow_log_%02d\n", i)
end

plot_md[#plot_md+1] = ""

local file = io.output("slow_request.md", "w+")
      assert(file:write(table.concat(plot_md, "\n")))
      file:close()

-- 生成 html 文件
local gen_html = os.execute("lua prettify.lua slow_request lua preview")
if gen_html ~= 0 then
    print("exec split command failed")
    os.exit(104)
end

-- 删除临时文件
local del_files = os.execute("rm -rf slow_log_*.lua; ls -d /tmp/lua_* | grep -v -E 'flot|api' | xargs rm -rf")
if del_files ~= 0 then
    print("exec rm command failed")
    os.exit(105)
end
