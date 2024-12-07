#!/usr/bin/ruby

class Guard
  NORTH = 0
  EAST = 1 
  SOUTH = 2
  WEST = 3

  attr_accessor :x, :y, :map
  attr_reader :steps

  def initialize(x=0,y=0, new_dir = "^", input_map = nil)
    @x = x
    @y = y
    self.dir = new_dir
    @steps = 0
    @initial_x = x
    @initial_y = y
    @initial_dir = @dir
    @initial_map = input_map
    load_map @initial_map
  end

  def load_map text
    @map = text.split("\n").map do |l| l.split(//) end
  end

  def reset!
    @x = @initial_x
    @y = @initial_y
    @dir = @initial_dir
    @steps = 0
    @turn_record = []
    load_map @initial_map
  end

  def map_width
    return @map[0].length
  end

  def map_height
    return @map.length
  end

  def obstacle_at? x,y
    return @map[y][x] == "#"
  end

  def put_obstacle_at(x,y)
    @map[y][x] = "#"
  end

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
    @turn_record << "#{x},#{y},#{dir}"
    case @dir
    when NORTH then @dir = EAST
    when EAST then @dir = SOUTH
    when SOUTH then @dir = WEST
    when WEST then @dir = NORTH
    end
  end

  def step
    @steps += 1

    map[y][x] = "X" # leave a trail
    next_step = lookahead

    if next_step == "#" then 
      turn
      return nil
    end
    if next_step == "O" then return "escape" end # escape!

    case @dir
    when NORTH then @y -= 1
    when SOUTH then @y += 1
    when WEST then @x -= 1
    when EAST then @x += 1
    end

    @map[@y][@x] = sprite

    if @turn_record[0..-2].member? @turn_record[-1] then
      return "loop" # Whoops! we're going in circles!
    end

    return nil
  end

  def has_loop?
    while true
      result = step

      if result == "loop"
        puts "loop detected in #{steps} steps!"
        return true
      end

      if result == "escape"
        puts "guard escaped in #{steps} steps!"
        return false
      end
    end
  end
end

input_text = ARGF.read()

input_map = input_text.split("\n").map do |l| l.split(//) end

guard = nil

for y in (0..input_map.length-1)
  for x in (0..input_map[y].length-1)
    if input_map[y][x] =~ /[v^<>]/ then
      guard = Guard.new(x,y,input_map[y][x],input_text)
      guard.x = x
      guard.y = y
      guard.dir = input_map[y][x]
      break
    end
  end
end

place_curs=`tput cup 0 0`

# puts "map is:", input_map.map {|a| a.join("") }.join("\n")
puts "guard is at (#{guard.x},#{guard.y}) facing #{guard.dir}"

safe = 0

for x in 0..guard.map_width-1
  for y in 0..guard.map_height-1
    guard.reset!
    guard.step
    unless guard.obstacle_at? x,y
      guard.put_obstacle_at x,y
      # puts(guard.map.map { |a| a.join("") }.join("\n"))
      if guard.has_loop?
        safe += 1
      end
    end
  end
end

puts "There are #{safe} places to put obstacles"
