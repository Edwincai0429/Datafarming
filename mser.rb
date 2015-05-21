#!/usr/bin/env ruby -w

require 'rubygems' if RUBY_VERSION =~ /^1\.8/

class String
  # colorizing
  def colorize(color_code); "\e[#{color_code}m#{self}\e[0m"; end
  def red; colorize(31); end
  def yellow; colorize(33); end
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

if ARGV.length > 0

  puts 'x-bar,n'

  ARGV.each do |fname|
    data = File.readlines(fname)
    data.shift if data[0] =~ /[A-Za-z]/   # strip header if one present
    data.map! { |line| line.chomp.strip.to_f }
    m_stats = QuickStats.new
    warmup = [(data.length * 0.5).to_i, data.length - 10].min
    index = data.length - 1
    while index > (data.length - warmup) && index > 1
      m_stats.new_obs(data[index])
      index -= 1
    end
    best = [m_stats.std_err, m_stats.avg, warmup]

    while index > -1
      m_stats.new_obs(data[index])
      best = [m_stats.std_err, m_stats.avg, index] if m_stats.std_err < best[0]
      index -= 1
    end

    printf "%f,%d\n", best[1], data.length - best[2]
  end
else
  STDERR.puts
  STDERR.puts ' Must supply at least one argument.  Syntax:'
  STDERR.puts
  STDERR.puts "\truby #{$PROGRAM_NAME} filename(s)...".yellow
  STDERR.puts
  STDERR.puts ' The files specified as filenames (explicit list or wildcard)'
  STDERR.puts ' should be one column of output data per file, with no headers.'
  STDERR.puts ' Results are written to stdout and can be redirected as desired.'
  STDERR.puts
end
