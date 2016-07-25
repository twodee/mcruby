#!/usr/bin/env ruby

require 'mcruby'

server = Minecraft::Server.new

10.times do
  server.world.time = 13000
  sleep 1
  server.world.time = 0
  sleep 1
end

server.disconnect
