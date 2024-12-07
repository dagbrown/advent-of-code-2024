#!/usr/bin/ruby

def checkops_helper(ops, lhs, *args)
  if args.length > 0 then
    ops.split(//).map do |op|
      case op
      when "+"
        intermediate = lhs + args[0]
        result = checkops_helper(ops, intermediate, *(args[1..-1])) 
        if result then result else intermediate end
      when "*"
        intermediate = lhs * args[0]
        result = checkops_helper(ops, intermediate, *(args[1..-1])) 
        if result then result else intermediate end
      when "."
        intermediate = "#{lhs}#{args[0]}".to_i
        result = checkops_helper(ops, intermediate, *(args[1..-1])) 
        if result then result else intermediate end
      end
    end
  end
end

def checkops ops, *args
  checkops_helper( ops, *args).flatten.delete_if { |x| x.nil? }
end

operations = "+*."

sum = 0

answers = []

ARGF.each_line do |l|
  answer,question = l.split(": ")

  question_values = question.split(/ /).map { |s| s.to_i }

  answer=answer.to_i

  results = checkops(operations, *question_values)
  puts "#{answer}: #{question_values.inspect} => #{results.inspect} => #{results.member? answer}"

  if results.member? answer then
    answers << answer
  end
end

puts answers.inject(:+)
