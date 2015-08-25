#!/usr/bin/env ruby -w

design = []
while line = STDIN.gets
  design << line.strip.split(/[,;:]|\s+/)
end

num_rotations = (ARGV.shift || design[0].length).to_i
num_rotations.times do
  design.each_with_index do |dp, i|
    puts dp.join ','
    design[i] = dp.rotate
  end
end
