#!/usr/bin/env ruby -w

# The "cross" method creates a large combinatorial design by crossing all
# combinations of individual smaller designs.  It uses recursion to do so
# because we don't know how many designs there may be in the input set.
#
# The method takes an array of arrays, where each sub-array contains a
# single component design, and kicks off the recursive build process.
def cross(inputs, idx = 0, tmp = [], solution = [])
  if idx >= inputs.size
    solution << tmp
  else
    inputs[idx].each { |dp| cross(inputs, idx + 1, tmp + dp, solution) }
  end
  solution
end

# The remainder is effectively the "main" for this script
if __FILE__ == $PROGRAM_NAME
  require 'colorize'

  String.disable_colorization false

  require 'optparse'
  require_relative 'error_handling'

  help_msg = [
    'Create a crossed design from two or more input design files',
    'where each line is a design point.  The crossed design is',
    'written to ' + 'stdout'.blue + ' in CSV format.', '',
    'Syntax:',
    "\n\truby #{ErrorHandling.prog_name} [--help] filenames...".yellow, '',
    "Arguments in square brackets are optional.  A vertical bar '|'",
    'indicates valid alternatives for invoking the option.', '',
    '  --help | -h | -? | ?'.green,
    "\tProduce this help message.",
    '  filenames...'.green,
    "\tThe names of the files containing designs to be crossed.",
    "\tInput file data can be delimited by commas, semicolons,",
    "\tcolons, or whitespace."
  ]

  OptionParser.new do |opts|
    opts.banner = "Usage: #{$PROGRAM_NAME} [-h|--help] [filenames...[]"
    opts.on('-h', '-?', '--help') { ErrorHandling.clean_abort help_msg }
  end.parse!

  ErrorHandling.clean_abort help_msg if ARGV[0] == '?' || ARGV.length < 2

  input_array = []
  ARGV.each do |filename| # for each file given as a command-line arg...
    # open the file, read all the lines, and then for each line use
    # spaces, commas, colons, or semicolons to tokenize.
    input_array << File.open(filename).readlines.map do |line|
      line.strip.split(/[,:;]|\s+/)
    end
  end
  cross(input_array).each { |line| puts line.join(',') }
end
