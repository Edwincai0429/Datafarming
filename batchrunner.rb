#!/usr/bin/env ruby -w

# First, process any command-line arguments
outfile_name = "outfile"
while ARGV[0] && ARGV[0][0] == "-"
  case ARGV.shift
  when "--outfile", "-o"
    outfile_name = ARGV.shift
  else
    STDERR.puts "Unknown argument!"
  end
end

cmd = (STDERR.print "Enter command: "; gets.strip)
params = (STDERR.print "Enter parameters: "; gets.strip)
num_runs = (STDERR.print "Enter # runs: "; gets).to_i

(1..num_runs).each do |run|
  STDERR.print "run #{run}:",
  	`#{cmd} #{params} > #{outfile_name}-#{"%05d" % run}.csv`, "\n"
end
