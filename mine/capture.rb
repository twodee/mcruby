#!/usr/bin/env ruby -I..

require 'mcruby'
include Minecraft

server = Minecraft::Server.new
world = server.world
player = server.player

puts "First, move your player to the starting corner."
print "Then come back and hit Return."
gets

a = player.tile

puts "Second, move your player to the ending corner."
print "Then come back and hit Return."
gets

b = player.tile

least = a.min b
most = a.max b

a = least
b = most

(a.z..b.z).each do |z|
  (a.y..b.y).each do |y|
    (a.x..b.x).each do |x|
      position = Vector3.new(x, y, z)
      if world[position] == Block::WOOL
        puts "moveto #{position.x}, #{position.y}, #{position.z}"
      end
    end
  end
end

server.disconnect
