#!/usr/bin/env ruby

require 'socket'

module Minecraft

  class Server
    attr_reader :player, :world

    def initialize host = 'localhost', port = 4711
      @socket = TCPSocket.new(host, port)
      @player = Player.new self
      @world = World.new self
    end

    def chat msg
      send "chat.post(#{msg})"
    end

    def disconnect
      @socket.close
    end

    def send message
      @socket.write("#{message}\n".b)
    end

    def receive
      @socket.recv 1024
    end
  end 

  class World
    def initialize server
      @server = server
    end

    def [] v
      @server.send "world.getBlock(#{v.x},#{v.y},#{v.z})"
      @server.receive.lines.first.to_i #split(',').map(&:to_i))
    end

    def []= v, blockType
      @server.send "world.setBlock(#{v.x},#{v.y},#{v.z},#{blockType})"
    end

    def set x, y, z, blockType
      @server.send "world.setBlock(#{x},#{y},#{z},#{blockType})"
    end

    def time= value
      @server.send "world.time(#{value})"
    end

    def storm= enabled
      @server.send "world.setStorm(#{enabled})"
    end

    def day
      @server.send "world.time(0)"
    end
  end

  class Vector3
    def initialize *xyz
      @xyz = xyz.clone
    end

    def x
      @xyz[0]
    end

    def y
      @xyz[1]
    end
    
    def z
      @xyz[2]
    end

    def above
      Vector3.new(x, y + 1, z)
    end

    def below
      Vector3.new(x, y - 1, z)
    end

    def right
      Vector3.new(x + 1, y, z)
    end

    def left
      Vector3.new(x - 1, y, z)
    end

    def front
      Vector3.new(x, y, z + 1)
    end

    def back
      Vector3.new(x, y, z - 1)
    end

    def x= val
      @xyz[0] = val
    end

    def y= val
      @xyz[1] = val
    end
    
    def z= val
      @xyz[2] = val
    end

    def + other
      Vector3.new(x + other.x, y + other.y, z + other.z)
    end

    def - other
      Vector3.new(x - other.x, y - other.y, z - other.z)
    end

    def <=> other
      Vector3.new(x <=> other.x, y <=> other.y, z <=> other.z)
    end

    def min other
      Vector3.new([x, other.x].min, [y, other.y].min, [z, other.z].min)
    end

    def max other
      Vector3.new([x, other.x].max, [y, other.y].max, [z, other.z].max)
    end

    def to_is
      @xyz.map(&:to_i).join(',')
    end

    def to_fs
      @xyz.map(&:to_f).join(',')
    end

    def to_s
      "(#{x}, #{y}, #{z})"
    end
  end

  module Positionable
    def tile
      @server.send "#{tag}.getTile()"
      Vector3.new *(@server.receive.lines.first.split(',').map(&:to_i))
    end

    def tile= v
      @server.send "#{tag}.setTile(#{v.to_is})"
    end

    def position
      @server.send "#{tag}.getPos()"
      Vector3.new *(@server.receive.lines.first.split(',').map(&:to_f))
    end

    def position= v
      @server.send "#{tag}.setPos(#{v.to_fs})"
    end
  end

  class Player
    include Positionable

    def initialize server
      @server = server
    end

    def tag
      'player'
    end
  end

  module Block
    AIR = 0
    STONE = 1
    GRASS = 2
    DIRT = 3
    COBBLESTONE = 4
    WOOD_PLANKS = 5
    SAPLING = 6
    BEDROCK = 7
    WATER_FLOWING = 8
    WATER = WATER_FLOWING
    WATER_STATIONARY = 9
    LAVA_FLOWING = 10
    LAVA = LAVA_FLOWING
    LAVA_STATIONARY = 11
    SAND = 12
    GRAVEL = 13
    GOLD_ORE = 14
    IRON_ORE = 15
    COAL_ORE = 16
    WOOD = 17
    LEAVES = 18
    GLASS = 20
    LAPIS_LAZULI_ORE = 21
    LAPIS_LAZULI_BLOCK = 22
    SANDSTONE = 24
    BED = 26
    COBWEB = 30
    GRASS_TALL = 31
    WOOL = 35
    FLOWER_YELLOW = 37
    FLOWER_CYAN = 38
    MUSHROOM_BROWN = 39
    MUSHROOM_RED = 40
    GOLD_BLOCK = 41
    IRON_BLOCK = 42
    STONE_SLAB_DOUBLE = 43
    STONE_SLAB = 44
    BRICK_BLOCK = 45
    TNT = 46
    BOOKSHELF = 47
    MOSS_STONE = 48
    OBSIDIAN = 49
    TORCH = 50
    FIRE = 51
    STAIRS_WOOD = 53
    CHEST = 54
    DIAMOND_ORE = 56
    DIAMOND_BLOCK = 57
    CRAFTING_TABLE = 58
    FARMLAND = 60
    FURNACE_INACTIVE = 61
    FURNACE_ACTIVE = 62
    DOOR_WOOD = 64
    LADDER = 65
    STAIRS_COBBLESTONE = 67
    DOOR_IRON = 71
    REDSTONE_ORE = 73
    SNOW = 78
    ICE = 79
    SNOW_BLOCK = 80
    CACTUS = 81
    CLAY = 82
    SUGAR_CANE = 83
    FENCE = 85
    GLOWSTONE_BLOCK = 89
    BEDROCK_INVISIBLE = 95
    STONE_BRICK = 98
    GLASS_PANE = 102
    MELON = 103
    FENCE_GATE = 107
    GLOWING_OBSIDIAN = 246
    NETHER_REACTOR_CORE = 247
  end
end

# server = Minecraft::Server.new
# server.chat "Goodbye, Pluto!"
# 10.times do
  # server.world.time = 13000
  # sleep 1
  # server.world.time = 0
  # sleep 1
# end

# player = server.player
# world = server.world

# world[player.tile.below] = Minecraft::Block::TNT
# world[player.tile.above] = Minecraft::Block::TNT
# world[player.tile.left] = Minecraft::Block::TNT
# world[player.tile.right] = Minecraft::Block::TNT
# world[player.tile.back] = Minecraft::Block::TNT
# world[player.tile.front] = Minecraft::Block::TNT

# server.disconnect
