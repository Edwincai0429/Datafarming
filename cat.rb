#!/usr/bin/env ruby -w
# concatenate one or more inputs to stdout

require 'colorize'

String.disable_colorization false

require 'optparse'
require_relative 'error_handling'

help_msg = [
  'Concatenate one or more input files, or ' + 'stdin'.blue +
    ', to ' + 'stdout'.blue + '.', '',
  'Syntax:',
  "\n\truby #{ErrorHandling.prog_name} [--help] [filenames...]".yellow, '',
  "Arguments in square brackets are optional.  A vertical bar '|'",
  'indicates valid alternatives for invoking the option.', '',
  '  --help | -h | -? | ?'.green,
  "\tProduce this help message.",
  '  filenames...'.green,
  "\tThe name[s] of the file[s] to be concatenated.",
  "\tRead from " + 'stdin'.blue + ' if no files are specified.'
]

OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} [-h|--help] [filenames...[]"
  opts.on('-h', '-?', '--help') { ErrorHandling.clean_abort help_msg }
end.parse!

ErrorHandling.clean_abort help_msg if ARGV[0] == '?'

ARGF.each { |line| print line }
