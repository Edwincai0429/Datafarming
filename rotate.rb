#!/usr/bin/env ruby -w

require 'colorize'
require_relative 'error_handling'

String.disable_colorization false

def help_msg
  clean_abort [
    'Syntax:',
    "\n\truby #{$PROGRAM_NAME.split(%r{/|\\})[-1]} [--help]".yellow +
    " [--rotations #] [--size #] [file_name]\n".yellow,
    "Arguments in square brackets are optional.  In the following, '|'",
    'indicates valid alternatives for invoking the option.', '',
    '  --help | -h | -? | ?'.green,
    "\tProduce this help message.",
    '  --rotations | -r'.green,
    "\t# specifies the number of rotations. A value of 1 means print the",
    "\tbase design.  If this option is not specified the number of rotations",
    "\tdefaults to the number of columns in the design.  The specified value",
    "\tcannot exceed the number of columns in the design being used.",
    '  --size | -s'.green,
    "\t# specifies the desired number of levels in the NOLH (17, 33, 65, 129,",
    "\tor 257).  Defaults to the smallest design which can accommodate the",
    "\tnumber of factors if this option is not specified.",
    '  file_name'.green,
    "\tThe name of a file containing the factor specifications, in exactly",
    "\tthe same format they would be specified in the factor settings fields",
    "\tof the NOLH spreadsheet, i.e., the first line is the set of minimum",
    "\trange values for each factor; the second line is maximum range values;",
    "\tand the third is the number of decimal places to use for the range",
    "\tscaling.  If no filename is given, the user can enter the values",
    "\tinteractively in the specified form (no prompts are given) or use",
    "\tfile redirection with '<'.", '',
    'Options may be given in any order, but must come before the file name',
    'if one is provided.  The "--help" option supersedes any other choices.',
    '', 'Results are written to ' + 'stdout'.light_blue +
    ', and can be redirected as desired.'
  ]
end

begin
  require_relative './nolh_designs.rb'
rescue LoadError
  clean_abort [
    'ALERT: Unable to find the file "nolh_designs.rb"!'.red,
    'Correct this by installing '.yellow +
    'nolh_designs.rb'.red + ' into'.yellow,
    'the same directory location as '.yellow + '#{$0}'.red + '.'.yellow
  ]
end

# Scaler objects will rescale a Latin Hypercube design from standard units
# to a range as specified by min, max, and num_decimals
class Scaler
  def initialize(min, max, num_decimals, lh_max = 17)
    @min = min
    @range = (max - min) / (lh_max - 1).to_r
    @scale_factor = 10.to_r**num_decimals
  end

  def scale(value)
    new_value = @min + @range * (value.to_r - 1.to_r)
    if @scale_factor == 1
      new_value.round
    else
      ((@scale_factor * new_value).round / @scale_factor).to_f
    end
  end
end

while ARGV[0] && (ARGV[0][0] == '-' || ARGV[0][0] == 45 || ARGV[0][0] == '?')
  current_value = ARGV.shift
  case current_value
  when '--rotations', '-r'
    num_rotations = ARGV.shift.to_i
  when '--size', '-s'
    lh_size = ARGV.shift.to_i
  when '--help', '-h', '-help', '-?', '?'
    help_msg
  else
    err_msg [
      'Unknown argument: '.red + current_value.yellow
    ]
    help_msg
  end
end

begin
  min_values = ARGF.gets.strip.split(/[,;:]|\s+/).map(&:to_f)
  max_values = ARGF.gets.strip.split(/[,;:]|\s+/).map(&:to_f)
  decimals = ARGF.gets.strip.split(/[,;:]|\s+/).map(&:to_i)
rescue StandardError => e
  err_msg [e.message.red]
  help_msg
end

n = min_values.size
if max_values.size != n || decimals.size != n
  err_msg ['Unequal counts for min, max, and decimals'.red]
  help_msg
end
minimal_size = case min_values.size
               when 1..7
                 17
               when 8..11
                 33
               when 12..16
                 65
               when 17..22
                 129
               when 23..29
                 257
               else
                 clean_abort [
                   'invalid number of factors'.red
                 ]
                 help_msg
               end

lh_size ||= minimal_size

clean_abort [
  "Latin hypercube size of #{lh_size} is too small for #{n} factors.".red
] if lh_size < minimal_size

clean_abort [
  "Invalid Latin hypercube size: #{lh_size}".red,
  'Use 17, 33, 65, 129, or 257.'.yellow
] unless DESIGN_TABLE.keys.include?(lh_size)

factor = Array.new(n) do |i|
  Scaler.new(min_values[i], max_values[i], decimals[i], lh_size)
end

design = DESIGN_TABLE[lh_size]

num_columns = design[0].length
num_rotations ||= num_columns
clean_abort [
  'Requested rotation exceeds number of columns in latin hypercube '.red +
  "(#{num_columns})".red
] if num_rotations > num_columns

mid_range = lh_size / 2
num_rotations.times do |rotation_num|
  design.each_with_index do |dp, i|
    scaled_dp = dp.slice(0, n).map.with_index { |x, k| factor[k].scale(x) }
    puts scaled_dp.join "\t" unless rotation_num > 0 && i == mid_range
    design[i] = dp.rotate
  end
end
