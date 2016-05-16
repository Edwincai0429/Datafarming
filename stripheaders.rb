#! /usr/bin/env ruby -w

# Strip header line out of file(s)

require 'colorize'

String.disable_colorization false

require 'optparse'
require_relative 'error_handling'

help_msg = [
  'Strip headers out of one or more file(s) to convert them to data-only.', '',
  'If filenames are specified, a backup is made for each file with',
  "suffix '.orig' appended to the original filename and changes will",
  'be made in-place in the original file.  If no filenames are given,',
  'the script reads from ' + 'stdin'.blue + ' and writes to ' +
    'stdout'.blue + '.  In either case,',
  'the first line of each input file is removed.', '',
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

$-i = '.orig' # specify backup suffix

oldfilename = ''

ARGF.each do |line|
  if ARGF.filename == oldfilename   # If it's an old file
    puts line                       # copy lines through.
  else                              # If it's a new file remember it
    oldfilename = ARGF.filename     # but don't copy the first line.
  end
end
