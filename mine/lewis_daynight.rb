#!/usr/bin/env ruby -I..

require 'mcruby'

server = Minecraft::Server.new

puts "running"
sleep 10

server.chat "does anyone want to guard my house?"

440000.times do
  server.world.time = 0
  sleep 10
  server.world.time = 13000
  sleep 10
end

server.disconnect
