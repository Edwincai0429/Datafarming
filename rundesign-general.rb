#!/usr/bin/env ruby -w

print = false   # default is to run rather than print
destructive = false   # default is non-destructive for output file

while ARGV[0] && (ARGV[0][0] == "-" || ARGV[0][0] == 45)
  case ARGV.shift
  when "--print", "-p"
    print = true
  when "--destructive", "-d"
    destructive = false
  else
    STDERR.puts "Unknown argument!"
  end
end

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
  File.delete(output_file_name) if destructive && File.exists?(output_file_name)

  reps.times do
    design_pts.each do |design_pt|
      exe_line = "#{cmd} #{design_pt} >> #{output_file_name}"
      if print
        puts exe_line
      else
        result = `#{exe_line}`
        STDERR.puts result if result =~ /\S/
      end
    end
  end
else
  STDERR.puts "\n  This script requires 4 command line args:"
  STDERR.puts "\tThe command to be run (MUST be in single quotes)"
  STDERR.puts "\tThe name of the DOE file (scaled, no headers or extra columns)"
  STDERR.puts "\tThe number of times to replicate each design point"
  STDERR.puts "\tThe name of the output file to which results will be sent\n"
  STDERR.puts "\n  Note: run-time options, if present, must be specified"
  STDERR.puts "  before the 4 required command-line arguments."
  STDERR.puts "\n  Options:"
  STDERR.puts "\n\t--print or -p: print to STDOUT rather than executing"
  STDERR.puts "\n\t--destructive or -d: delete pre-existing output file\n\n"
end
