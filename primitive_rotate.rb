#!/usr/bin/env ruby -w

require_relative './nolh_designs.rb'

# Scaler objects will rescale a Latin Hypercube design from standard units
# to a range as specified by min, max, and num_decimals
class Scaler
  def initialize(min, max, num_decimals, lh_max = 17)
    @min = min
    @range = (max - min) / (lh_max - 1).to_r
    @scale_factor = 10r**num_decimals
  end

  def scale(value)
    new_value = @min + @range * (value.to_r - 1r)
    if @scale_factor == 1
      new_value.round
    else
      ((@scale_factor * new_value).round / @scale_factor).to_f
    end
  end
end

min_values = STDIN.gets.strip.split(/[,;:]|\s+/).map(&:to_f)
max_values = STDIN.gets.strip.split(/[,;:]|\s+/).map(&:to_f)
decimals = STDIN.gets.strip.split(/[,;:]|\s+/).map(&:to_i)

n = min_values.size
return if max_values.size != n || decimals.size != n
lh_size = case min_values.size
          when 1..7
            17
          when 8..11
            33
          when 12..16
            65
          when 17..22
            129
          when 23..29
            257
          else
            fail 'invalid number of factors'
  end

factor = Array.new(n) do |i|
  Scaler.new(min_values[i], max_values[i], decimals[i], lh_size)
end

design = DESIGN_TABLE[lh_size]
mid_range = lh_size / 2
num_rotations = (ARGV.shift || design[0].length).to_i
num_rotations.times do |rotation_num|
  design.each_with_index do |dp, i|
    scaled_dp = dp.slice(0, n).map.with_index { |x, k| factor[k].scale(x) }
    puts scaled_dp.join "\t" unless rotation_num > 0 && i == mid_range
    design[i] = dp.rotate
  end
end
