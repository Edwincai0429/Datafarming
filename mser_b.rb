#!/usr/bin/env ruby -w

require 'rubygems' if RUBY_VERSION =~ /^1\.8/

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def yellow
    colorize(33)
  end
end

begin
  require 'quickstats'
rescue LoadError
  STDERR.puts "\n\tALERT: quickstats gem is not installed!".red
  STDERR.puts "\tIf you have network connectivity, type:"
  STDERR.puts "\n\t\tgem install quickstats\n".yellow
  STDERR.puts "\t(Admin privileges may be required.)\n\n"
  exit(-1)
end

def readbatch(data, index, b)
  (data[(index + 1 - b)..index].inject { |x, sum| sum += x }) / b
end

if ARGV.length > 0
  batch_size = 1

  batch_size = ARGV.shift.to_i if ARGV[0].to_i > 0

  puts 'x-bar,n'

  ARGV.each do |fname|
    data = File.readlines(fname)
    data.shift if data[0] =~ /[A-Za-z]/
    data.map! { |line| line.chomp.strip.to_f }
    mser_stats = QuickStats.new
    warmup = [(data.length * 0.5).to_i, data.length - 10].min
    index = data.length - 1
    while index > (data.length - warmup) && index > batch_size
      mser_stats.new_obs(readbatch(data, index, batch_size))
      index -= batch_size
    end
    best = [mser_stats.std_err, mser_stats.avg, warmup]

    while index >= batch_size - 1
      mser_stats.new_obs(readbatch(data, index, batch_size))
      if mser_stats.std_err < best[0]
        best = [mser_stats.std_err, mser_stats.avg, index]
      end
      index -= batch_size
    end

    printf "%f,%d\n", best[1], data.length - best[2]
  end
else
  STDERR.puts
  STDERR.puts ' Must supply at least one argument.  Syntax:'
  STDERR.puts
  STDERR.puts "\truby #{$PROGRAM_NAME} [batchsize] filename(s)...".yellow
  STDERR.puts
  STDERR.puts ' The batchsize is optional and defaults to 1 if not provided.'
  STDERR.puts ' The files specified as filenames (explicit list or wildcard)'
  STDERR.puts ' should be one column of output data per file, with no headers.'
  STDERR.puts ' Results are written to stdout and can be redirected as desired.'
  STDERR.puts
end
