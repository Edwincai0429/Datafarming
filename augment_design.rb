#!/usr/bin/env ruby -w

# This script generates star points to augment a fractional factorial
# so you can check for quadratic effects.

require 'colorize'

String.disable_colorization false

require 'optparse'
require_relative 'error_handling'

help_msg = [
  'Generate star points to augment a fractional factorial ' \
  'with quadratic effects.',
  'Results are white-space delimited data written to ' +
    'stdout'.light_blue + ', and can be redirected', 'as desired.', '',
  'Syntax:',
  "\n\truby #{ErrorHandling.prog_name} [--help] FACTOR_INFO".yellow, '',
  "Arguments in square brackets are optional.  A vertical bar '|'",
  'indicates valid alternatives for invoking the option.', '',
  '  --help | -h | -? | ?'.green,
  "\tProduce this help message.",
  '  FACTOR_INFO'.green,
  "\tEITHER the number of factors (produces standardized +/-1 design),",
  "\tOR pairs of values " + 'low1 hi1 low2 hi2...lowN hiN'.green +
    ' for each of the',
  "\tN factors.", ''
]

OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} [-h|--help] [number of factors]"
  opts.on('-h', '-?', '--help') { ErrorHandling.clean_abort help_msg }
end.parse!

if ARGV.length == 0 || (ARGV[0] == '?') || (ARGV.length > 1 && ARGV.length.odd?)
  ErrorHandling.clean_abort help_msg
else
  num_factors = 0
  if ARGV.length == 1
    num_factors = ARGV.shift.to_i
    x = Array.new(num_factors, ' 0')
    ranges = Array.new(2 * num_factors)
    ranges.each_index { |i| ranges[i] = (i.even? ? '-1' : ' 1') }
  else
    num_factors = ARGV.length / 2
    x = Array.new(num_factors)
    ranges = ARGV
    num_factors.times do |i|
      x[i] = 0.5 * (ranges[2 * i].to_f + ranges[2 * i + 1].to_f)
    end
  end
  # create and print an array at the global center point (0,0,...,0)
  puts x.join(' ')

  # now generate and print the star points at +/-1 along each factor axis
  num_factors.times do |i|
    y = x.clone
    y[i] = ranges[2 * i]
    puts y.join(' ')
    y[i] = ranges[2 * i + 1]
    puts y.join(' ')
  end
end
