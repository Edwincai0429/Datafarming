#!/usr/bin/env ruby -w

# Ruby script to pool the columns of multiple csv files

require 'colorize'
require 'optparse'
require_relative 'error_handling'

String.disable_colorization false

help_msg = [
  'Pool the output from two or more CSV files to a single output file.', '',
  'The first line of output is the list of filenames that were the',
  'source files of the data to be merged.  Subsequent lines are the',
  'contents of those files, and are assumed to be in CSV format.',
  'Output is written to ' + 'stdout'.blue + ' in CSV format.', '',
  'Syntax:',
  "\n\truby #{ErrorHandling.prog_name} [--help] ".yellow +
    '[--no-labels] filenames...'.yellow, '',
  "Arguments in square brackets are optional.  A vertical bar '|'",
  'indicates valid alternatives for invoking the option.', '',
  '  --help | -h | -? | ?'.green,
  "\tProduce this help message.",
  '  --no-labels | -n'.green,
  "\tSpecify that individual files do not have labels.",
  '  filenames...'.green,
  "\tThe names of two or more files containing data to be pooled.",
  "\tInput file data can be delimited by commas, semicolons,",
  "\tcolons, or whitespace."
]

no_labels = false
OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} [-h|--help] [filenames...[]"
  opts.on('-h', '-?', '--help') { ErrorHandling.clean_abort help_msg }
  opts.on('-n', '--no-labels') { no_labels = true }
end.parse!

ErrorHandling.clean_abort help_msg if ARGV[0] == '?' || ARGV.length < 2

old_filename = nil
line_set = nil
allfiles = []

# Read in all data from all files, resetting the line_set
# for each new file
ARGF.each do |line|
  if ARGF.filename == old_filename
    line_set << line.strip
  else
    old_filename = ARGF.filename
    line_set && allfiles << line_set
    line_set = []
    line_set << if no_labels
      line.strip
    else
      line.strip.split(',').map{ |elt| old_filename + '::' + elt }.join(',')
    end
  end
end
allfiles << line_set

# Equalize all vectors to same length by padding with nils if needed...
max_length = allfiles.map(&:length).max
allfiles.each { |v| v[max_length - 1] = nil unless v.length == max_length }
# ...and output all the data
allfiles.transpose.each { |row| puts row.join(',') }
