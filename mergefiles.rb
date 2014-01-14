#!/usr/bin/env ruby -w

# Ruby script to merge csv files
#
# The first line of output is the list of filenames that were the
# source of the data to be merged.  Subsequent lines are the
# contents of that set of files.
#
# If "-n" or "--no-labels" is provided as a command-line argument,
# then labels within the individual files are NOT copied through.
#
# Output is sent to STDOUT, where it can be redirected as desired.

# First, process any command-line arguments
no_labels = false
while ARGV[0] && ARGV[0][0] == "-"
  case ARGV.shift
  when "--no-labels", "-n"
    no_labels = true
  else
    STDERR.puts "Unknown argument!"
  end
end

old_filename = nil
line_set = nil
allfiles = []
labels = ARGV.join(",")

# Read in all data from all files, resetting the line_set
# for each new file
ARGF.each do |line|
  if ARGF.filename == old_filename
    line_set << line.strip
  else
    old_filename = ARGF.filename
    line_set && allfiles << line_set
    line_set = []
    line_set << line.strip unless no_labels
  end
end
allfiles << line_set

# Equalize all vectors to same length by padding with nils if needed
max_length = (allfiles.map {|v| v.length}).max
allfiles.each {|v| v[max_length - 1] = nil unless v.length == max_length}
# Construct and print the filename labels...
puts labels
# ...and output all the data
allfiles.transpose.each {|row| puts row.join(",")}
