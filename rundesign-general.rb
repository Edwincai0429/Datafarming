#!/usr/bin/env ruby -w

if ARGV.length == 4
  # What shall we run today?
  cmd = ARGV.shift
  # Suck in all the design points from the file specified as the next
  # argument, strip the whitespace, and put the results in an array
  design_pts = File.readlines(ARGV.shift).map {|line| line.strip!}
  # How many times do we want to do this?
  reps = ARGV.shift.to_i
  # Where do the results go?
  output_file_name = ARGV.shift
  File.delete(output_file_name) if File.exists?(output_file_name)

  reps.times do
    design_pts.each do |design_pt|
      result = `#{cmd} #{design_pt} >> #{output_file_name}`
      STDERR.puts result if result =~ /\S/
    end
  end
else
  STDERR.puts "\n  This script requires 4 command line args:"
  STDERR.puts "\tThe command to be run (MUST be in single quotes)"
  STDERR.puts "\tThe name of the DOE file (scaled, no headers or extra columns)"
  STDERR.puts "\tThe number of times to replicate each design point"
  STDERR.puts "\tThe name of the output file to which results will be sent\n\n"
end