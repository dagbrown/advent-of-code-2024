#!/usr/bin/ruby

valpairs = []

ARGF.each_line do |line|
    numbers = line.chomp.split(/ +/).map {|x| x.to_i }
    valpairs.push numbers
end

list1 = valpairs.map { |x| x[0] }.sort
list2 = valpairs.map { |x| x[1] }.sort
newvalpairs = [ list1, list2 ].transpose
distance = newvalpairs.map { |x| (x[1]-x[0]).abs }.inject :+

similarityscore = list1.map { |leftval|
  list2.find_all { |v| leftval == v }.length  * leftval
}.inject :+

p distance
p similarityscore
