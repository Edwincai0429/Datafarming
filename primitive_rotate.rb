#!/usr/bin/env ruby -w

require_relative './design_table.rb'

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

lh_size = 17

scale_obj = [
  Scaler.new(-8, 8, 0, lh_size),
  Scaler.new(-16, 16, 0, lh_size),
  Scaler.new(-8, 8, 1, lh_size),
  Scaler.new(-8, 8, 2, lh_size),
  Scaler.new(1, 17, 0, lh_size),
  Scaler.new(0, 1, 0, lh_size),
  Scaler.new(0, 10, 2, lh_size)
]

design = DESIGN_TABLE[lh_size]
num_rotations = (ARGV.shift || design[0].length).to_i
num_rotations.times do
  design.each_with_index do |dp, i|
    scaled_dp = dp.map.with_index { |x, k| scale_obj[k].scale(x) }
    puts scaled_dp.join "\t"
    design[i] = dp.rotate
  end
end
