#!/usr/bin/env ruby -W0
# converts blank separated files to csv

require 'colorize'

String.disable_colorization false

require 'optparse'
require_relative 'error_handling'

help_msg = [
  'Convert whitespace delimited data to comma separated values.', '',
  'If filenames are specified, a backup is made for each file with',
  "suffix '.orig' appended to the original filename and changes will",
  'be made in-place in the original file.  If no filenames are given,',
  'the script reads from ' + 'stdin'.blue + ' and writes to ' +
    'stdout'.blue + '.  In either case,',
  'all occurrences of one or more whitespace characters are replaced',
  'by commas.', '',
  'Syntax:',
  "\n\truby #{ErrorHandling.prog_name} [--help] [filenames...]".yellow, '',
  "Arguments in square brackets are optional.  A vertical bar '|'",
  'indicates valid alternatives for invoking the option.', '',
  '  --help | -h | -? | ?'.green,
  "\tProduce this help message.",
  '  filenames...'.green,
  "\tThe name[s] of the file[s] to be converted."
]

OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} [-h|--help] [filenames...[]"
  opts.on('-h', '-?', '--help') { ErrorHandling.clean_abort help_msg }
end.parse!

ErrorHandling.clean_abort help_msg if ARGV[0] == '?'

$-i = '.orig'
ARGF.each { |line| puts line.strip.gsub(/\s+/, ',') }
