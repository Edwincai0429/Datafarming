#!/usr/bin/env ruby -w
cmd = (STDERR.print "Enter command: "; gets.strip)
params = (STDERR.print "Enter parameters: "; gets.strip)
num_runs = (STDERR.print "Enter # runs: "; gets).to_i

(1..num_runs).each do |run|
  STDERR.print "run #{run}:",
  	`#{cmd} #{params} > outfile-#{"%05d" % run}.csv`, "\n"
end
