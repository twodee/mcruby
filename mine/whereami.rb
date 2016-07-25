#!/usr/bin/env ruby -I..

require 'mcruby'
include Minecraft

server = Minecraft::Server.new
player = server.player
puts player.tile
server.disconnect
