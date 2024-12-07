#!/usr/bin/ruby

class Guard
  NORTH = 0
  EAST = 1 
  SOUTH = 2
  WEST = 3

  def initialize(x=0,y=0, new_dir = "^", map = nil)
    @x = x
    @y = y
    self.dir = new_dir
  end

  attr_accessor :x, :y, :map

  def dir=(new_dir)
    if new_dir == "^" then
      @dir = NORTH
    elsif new_dir == ">" then
      @dir = EAST
    elsif new_dir == "v" then
      @dir = SOUTH
    elsif new_dir == "<" then
      @dir = WEST
    end
  end

  def dir
    case @dir
    when NORTH then "NORTH"
    when SOUTH then "SOUTH"
    when EAST then "EAST"
    when WEST then "WEST"
    end
  end

  def sprite
    case @dir
    when NORTH then "^"
    when SOUTH then "v"
    when EAST then ">"
    when WEST then "<"
    end
  end

  def lookahead
    case @dir
    when NORTH then
      if y == 0 then 
        return "O"
      else
        return @map[y-1][x]
      end
    when SOUTH then
      if y == @map.length-1 then
        return "O"
      else
        return @map[y+1][x]
      end
    when EAST then
      if x == @map[y].length-1 then
        return "O"
      else
        return @map[y][x+1]
      end
    when WEST then
      if x == 0 then
        return "O"
      else
        return @map[y][x-1]
      end
    end
  end

  def turn
    case @dir
    when NORTH then @dir = EAST
    when EAST then @dir = SOUTH
    when SOUTH then @dir = WEST
    when WEST then @dir = NORTH
    end
  end

  def step
    map[y][x] = "X" # leave a trail
    next_step = lookahead
    if next_step == "#" then turn end
    if next_step == "O" then return true end # escape!

    case @dir
    when NORTH then @y -= 1
    when SOUTH then @y += 1
    when WEST then @x -= 1
    when EAST then @x += 1
    end

    p y
    @map[@y][@x] = sprite
    return false
  end
end

input_map = ARGF.read().split("\n").map do |l| l.split(//) end

guard = Guard.new

guard.map = input_map

for y in (0..input_map.length-1)
  for x in (0..input_map[y].length-1)
    if input_map[y][x] =~ /[v^<>]/ then
      guard.x = x
      guard.y = y
      guard.dir = input_map[y][x]
      break
    end
  end
end

place_curs=`tput cup 0 0`

puts "map is:", input_map.map {|a| a.join("") }.join("\n")
puts "guard is at (#{guard.x},#{guard.y}) facing #{guard.dir}"

until guard.step
  puts "#{place_curs}map is:", input_map.map {|a| a.join("") }.join("\n")
  puts "guard is at (#{guard.x},#{guard.y}) facing #{guard.dir}"
end

output_map = guard.map

puts "Guard visited #{output_map.flatten.grep(/X/).length} distinct locations"
