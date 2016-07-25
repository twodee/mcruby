#!/usr/bin/env ruby -I..

require 'mcruby'

server = Minecraft::Server.new
server.world.time = 0
server.disconnect
