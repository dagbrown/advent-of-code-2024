#!/usr/bin/ruby

def pairs(list)
  (1..list.length-1).to_a.map do |i| [list[i-1],list[i]] end
end

def safe(*num)
  increasing = false
  decreasing = false

  biggest_diff = 0
  smallest_diff = 99999

  pairs(num).each do |x,y|
    if y > x then increasing = true end
    if y < x then decreasing = true end

    if (y - x).abs > biggest_diff then
      biggest_diff = (y - x).abs
    end

    if (y - x).abs < smallest_diff then
      smallest_diff = (y - x).abs
    end
  end

  if increasing and decreasing then return false end
  if biggest_diff > 3 then return false end
  if smallest_diff < 1 then return false end
  return true
end

def sublists(nums)
  sl = []
  (0..(nums.length-1)).each do |ind|
    sl.push nums.dup
    sl[-1].delete_at ind
  end
  sl
end

def dampsafe(*nums)
  if safe(*nums) then return true end

  s = sublists(nums)
  s.map { |l| safe(*l) }.inject { |x,y| x or y }
end

numbers=ARGF.read.split(/\n/).map { |l| l.split(/\s+/).map { |s| s.to_i } }

safe_count = 0

numbers.each do |n|
  if safe(*n) then
    puts n.inspect, "safe"
    safe_count += 1
  else
    puts n.inspect, "unsafe"
  end
end

damp_safe_count = 0

numbers.each do |n|
  if dampsafe(*n)  then
    puts n.inspect, "safe under dampening"
    damp_safe_count += 1
  else
    puts n.inspect, "still unsafe"
  end
end

p safe_count
p damp_safe_count
