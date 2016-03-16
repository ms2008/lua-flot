-- nginx_lua_gc.lua
local flot = require 'flot'
local socket = require 'socket'

local sin, cos, std = {},{},{}
for i = 1,100 do
   -- local x = i/10
   local x = i
   math.randomseed(socket.gettime()*1000)
   math.random(); math.random(); math.random()
   sin[i] = {x,math.random(100,300)}
   socket.sleep(0.0001)
   cos[i] = {x,math.random(100,300)}
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

p:add_series("Worker id 17683",sin)
p:add_series("Worker id 17684",cos)
p:add_series("Std",std,{points={show=true},color="#CB4B4B"})

flot.render(p)
