#!/usr/bin/env ruby -w

if RUBY_VERSION =~ /^1\.8/
  require 'rubygems'
end

# You must have the quickstats RubyGem installed.  Assuming
# you have network connectivity, type:
#
#     gem install quickstats
#
# Note that this may require admin privileges.
require 'quickstats'
require 'weightedstats'

def readbatch(data, index, b)
  (data[(index+1-b)..index].inject {|x,sum| sum+=x}) / b  
end

if ARGV.length > 0
  batch_size = 1
  if ARGV[0].to_i > 0
    batch_size = ARGV.shift.to_i
  end

  printf "x-bar,n\n"

  ws = WeightedStats.new

  ARGV.each do |fname|
    data = File.readlines(fname).map {|line| line.strip!.to_f}
    mser_stats = QuickStats.new
    warmup = [(data.length * 0.5).to_i, data.length - 10].min
    index = data.length - 1
    while index > (data.length - warmup)  && index > batch_size do
      mser_stats.new_obs(readbatch(data, index, batch_size))
      index -= batch_size
    end
    best = [mser_stats.std_err, mser_stats.avg, warmup]

    while index >= batch_size do
      mser_stats.new_obs(readbatch(data, index, batch_size))
      index -= batch_size
      if mser_stats.std_err < best[0]
        best = [mser_stats.std_err, mser_stats.avg, index]
      end
    end

    printf "%f,%d\n", best[1], data.length - best[2]
    ws.new_obs(best[1], data.length - best[2])

  end
  printf "avg = %f, std err = %f, df = %f\n", ws.avg, ws.std_err, ws.df
else
  STDERR.puts
  STDERR.puts " Must supply at least one argument.  Syntax:"
  STDERR.puts
  STDERR.puts "\truby #{$0} [batchsize] filename(s)..."
  STDERR.puts
  STDERR.puts " The batchsize is optional and defaults to 1 if not provided."
  STDERR.puts " The files specified as filenames (explicit list or wildcard)"
  STDERR.puts " should be one column of output data per file, with no headers."
  STDERR.puts " Results are written to stdout and can be redirected as desired."
  STDERR.puts
end

