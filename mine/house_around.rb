#!/usr/bin/env ruby -I..

require 'mcruby'

server = Minecraft::Server.new
world = server.world
center = server.player.tile

def line x, y, z

z = center.z + 5
for y in 0 .. 10
  for x in center.x - 5 .. center.x + 5
    world.set x, center.y + y, z, Minecraft::Block::MELON
  end
end

server.disconnect
