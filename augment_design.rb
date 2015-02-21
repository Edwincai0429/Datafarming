#!/usr/bin/env ruby -w

# This script generates the star points to augment a fractional factorial
# so you can check for quadratic effects.

num_factors = 0
if ARGV.length == 0 || (ARGV.length > 1 && ARGV.length % 2 == 1)
  STDERR.puts "Usage:"
  STDERR.puts "\t#{$0} number_of_factors"
  STDERR.puts "OR"
  STDERR.puts "\t#{$0} low1 hi1 low2 hi2...lowN hiN"
else
  if ARGV.length == 1
    num_factors = ARGV.shift.to_i
    x = Array.new(num_factors, " 0")
    ranges = Array.new(2 * num_factors)
    ranges.each_index {|i| ranges[i] = (i % 2 == 0 ? "-1" : " 1")}
  else
    num_factors = ARGV.length / 2
    x = Array.new(num_factors)
    ranges = ARGV
    num_factors.times do |i|
      x[i] = 0.5 * (ranges[2 * i].to_f + ranges[2 * i + 1].to_f)
    end
  end
  # create and pring an array at the global center point (0,0,...,0)
  puts x.join(" ")

  # now generate and print the star points at +/-1 along each factor axis
  num_factors.times do |i|
    y = x.clone
    y[i] = ranges[2 * i]
    puts y.join(" ")
    y[i] = ranges[2 * i + 1]
    puts y.join(" ")
  end
end
