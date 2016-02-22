----------------------------------------------------------------------------
-- Issue: ULUCU PHP Slow Request Log Analyzer
-- Copyright (C)2015 ULUCU Co.,Ltd. All Rights Reserved
-- Author: yufu.zhao <zyfu@ulucu.com> at 2016-02-17 10:21:15
----------------------------------------------------------------------------

local flot = require 'flot'

if not arg[1] then
    print("Usage: " .. arg[0] .. " slow_log")
    os.exit(-1)
end

local file = io.open(arg[1], "rb")

local request, upstream, std = {},{},{}
local i = 1

-- 平均数 Avg
local function avg_func(t)
    local sum = 0
    for i,v in pairs(t) do
        sum = sum + v
    end
    return sum / #t
end

-- 方差 Varp
local function varp_func(t)
    local avg = avg_func(t)
    local sub = 0
    for i,v in pairs(t) do
        sub = sub + (v - avg) ^ 2
    end
    return sub / #t
end

-- 标准差 StdDevP
local function stddevp_func(t)
    return math.sqrt(varp_func(t))
end

for line in file:lines() do
   -- local x = i/10
   local x = i
   local request_time, upstream_response_time= string.match(line, "^[%w%p]+ %+%d+ %d+ ([%d%.%-]+) ([%d%.%-]+)")
   -- print(request_time, upstream_response_time)
   -- print(x)

   request_time = tonumber(request_time) or 0
   upstream_response_time = tonumber(upstream_response_time) or 0

   request[i] = {x,request_time}
   upstream[i] = {x,upstream_response_time}
   local stddevp = stddevp_func({request[i][2], upstream[i][2]})
   if stddevp == 0 then
       stddevp = flot.null
   end
   std[i] = {x,stddevp}
   -- print(request[i][2], upstream[i][2], avg_func({request[i][2],upstream[i][2]}), stddevp)
   i = i + 1
end

file:close()

local p = flot.Plot {
    grid = {
       markings = {
          {xaxis={from=1200,to=3800},color="#FFEEFE"}
       },
       hoverable=true,autoHighlight=true,clickable=true,mouseActiveRadius=10
    },
    crosshair = {
        mode="x"
    },
    tooltip = {
        show=true,
        content="%s: value of %x is %y.3",
        shifts={x=-60,y=25}
    },
    shadowSize=0,
    width=1200, height=200
}

p:add_series("request_time",request,{lines={fill=false}})
p:add_series("upstream_time",upstream,{lines={fill=1}})
-- p:add_series("Std",std,{lines={fill=0.3},points={show=true},color="#CB4B4B"})

flot.render(p)
