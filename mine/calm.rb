#!/usr/bin/env ruby -I..

require 'mcruby'

server = Minecraft::Server.new
server.world.storm = (ARGV.length > 0 && ARGV[0] == 'true') ? true : false
server.disconnect
