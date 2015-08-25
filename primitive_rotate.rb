#!/usr/bin/env ruby -w

class Scaler
  def initialize(min, max, num_decimals, lh_max = 17)
    @min = min
    @range = max - min
    @lh_max = (lh_max - 1).to_r
    @scale_factor = 10**num_decimals
  end

  def scale(value)
    new_range = @range * (value.to_r - 1) / @lh_max
    if @scale_factor == 1
      @min + new_range.round
    else
      @min + (@scale_factor * new_range).round / @scale_factor.to_f
    end
  end
end

design = []
lh_size = 0
while line = STDIN.gets
  design << line.strip.split(/[,;:]|\s+/).map!(&:to_i)
  lh_size += 1
end

scale_obj = [
  Scaler.new(-8, 8, 0, lh_size),
  Scaler.new(-16, 16, 0, lh_size),
  Scaler.new(-8, 8, 1, lh_size),
  Scaler.new(-8, 8, 2, lh_size),
  Scaler.new(-8, 8, 3, lh_size),
  Scaler.new(-1, 1, 0, lh_size),
  Scaler.new(-1, 1, 6, lh_size)
]

num_rotations = (ARGV.shift || design[0].length).to_i
num_rotations.times do
  design.each_with_index do |dp, i|
    scaled_dp = dp.map.with_index { |x, k| scale_obj[k].scale(x) }
    puts scaled_dp.join ','
    design[i] = dp.rotate
  end
end
