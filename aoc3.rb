#!/usr/bin/ruby

input=ARGF.read

results = input.scan(/mul\(\d+,\d+\)|do\(\)|don\'t\(\)/)

do_eval = true

output = results.map do |op|
  if op == "don't()" then do_eval = false end
  if op == "do()" then do_eval = true end
  if do_eval and matchdata = op.match(/(\w+)\((\d+),(\d+)\)/)
  then
    oper = matchdata[1]
    x = matchdata[2].to_i
    y = matchdata[3].to_i

    if(oper == "mul")
      x * y
    end
  else
    0
  end
end

p results
p output

puts output.inject :+
