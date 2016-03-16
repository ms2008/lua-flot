-- nginx_status.lua
local flot = require 'flot'
local socket = require 'socket'

local sin, cos, std = {},{},{}
for i = 1,100 do
   -- local x = i/10
   local x = i
   math.randomseed(socket.gettime()*1000)
   math.random(); math.random(); math.random()
   sin[i] = {x,math.random(0,100)}
   socket.sleep(0.001)
   cos[i] = {x,math.random(0,100)}
   std[i] = {x,(sin[i][2] + cos[i][2])/2}
end

local p = flot.Plot {
    grid = {
       markings = {
          {xaxis={from=40,to=60},color="#FFEEFE"}
       }
    },
    width=1700, height=420
}

p:add_series("request_time",sin)
p:add_series("upstream_time",cos)
p:add_series("Std",std,{points={show=true},color="#CB4B4B"})

flot.render(p)
