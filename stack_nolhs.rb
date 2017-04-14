#!/usr/bin/env ruby -w

require 'colorize'
String.disable_colorization false

require_relative 'error_handling'

begin
  require_relative './nolh_designs'
rescue LoadError
  ErrorHandling.cant_find 'nolh_designs.rb'
end

help_msg = [
  'Generate scaled Latin hypercube designs with rotation and stacking. ',
  'Results are white-space delimited data written to ' +
    'stdout'.light_blue + ', and can be', 'redirected as desired.', '',
  'Syntax:',
  "\n\truby #{$PROGRAM_NAME.split(%r{/|\\})[-1]} [--help]".yellow +
    " [--rotations #] [--size #] [file_name]\n".yellow,
  "Arguments in square brackets are optional.  A vertical bar '|'",
  'indicates valid alternatives for invoking the option.', '',
  '  --help | -h | -? | ?'.green,
  "\tProduce this help message.  Supersedes any other choices.",
  '  --rotations # | -r #'.green,
  "\t# specifies the number of rotations. A value of 1 means print the",
  "\tbase design.  If this option is not specified the number of rotations",
  "\tdefaults to the number of columns in the design.  The specified value",
  "\tcannot exceed the number of columns in the design being used.",
  '  --size # | -s #'.green,
  "\t# specifies the desired number of levels in the NOLH (17, 33, 65, 129,",
  "\tor 257).  Defaults to the smallest design which can accommodate the",
  "\tnumber of factors if this option is not specified.",
  '  --excel-style-input # | -e #'.green,
  "\tSpecify factor ranges and decimals as in the NOLH spreadsheet, i.e.,",
  "\tthe first line is the set of minimum range values for each factor;",
  "\tthe second line is maximum range values; and the third is the number",
  "\tof decimal places to use for the range scaling.  Without this option,",
  "\tthe default input format is one line per factor, comprised of the min,",
  "\tmax, and number of decimal places separated by commas or whitespace.",
  '  file_name'.green,
  "\tThe name of a file containing the factor specifications.  If no",
  "\tfilename is given, the user can enter the values interactively in",
  "\tthe desired form or use file redirection with '<'.", '',
  'Options may be given in any order, but must come before the file name',
  'if one is provided.'
]

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

excel_style_inputs = false
while ARGV[0] && (ARGV[0][0] == '-' || ARGV[0][0] == 45 || ARGV[0][0] == '?')
  current_value = ARGV.shift
  case current_value
  when '--rotations', '-r'
    num_rotations = ARGV.shift.to_i
  when '--size', '-s'
    lh_size = ARGV.shift.to_i
    unless NOLH::DESIGN_TABLE.keys.include?(lh_size)
      ErrorHandling.clean_abort [
        "Invalid Latin hypercube size: #{lh_size}".red,
        'Use 17, 33, 65, 129, or 257.'.yellow
      ]
    end
  when '--excel-style-input', '-e'
    excel_style_inputs = true
  when '--help', '-h', '-help', '-?', '?'
    ErrorHandling.clean_abort help_msg
  else
    ErrorHandling.message ['Unknown argument: '.red + current_value.yellow]
    ErrorHandling.clean_abort help_msg
  end
end

begin
  if excel_style_inputs
    if ARGV.empty?
      STDERR.puts  'Enter one line of min values, one of max values,'.green +
      ' and one of #decimals.'.green
    end
    min_values = ARGF.gets.strip.split(/\s*[,;:]\s*|\s+/).map(&:to_f)
    max_values = ARGF.gets.strip.split(/\s*[,;:]\s*|\s+/).map(&:to_f)
    decimals = ARGF.gets.strip.split(/\s*[,;:]\s*|\s+/).map(&:to_i)
  else
    if ARGV.empty?
      STDERR.puts  'To terminate input enter '.green + 'ctrl-d'.cyan +
        ' (Mac/Unix/Linux)'.green + ' or '.green + 'ctrl-z'.cyan +
        ' (Windows).'.green
      STDERR.puts  'Enter ranges for each factor on a separate line.'.green
      STDERR.puts  "\nMIN\tMAX\t#DIGITS".cyan
    end
    min_values = []
    max_values = []
    decimals = []
    while line = ARGF.gets
      values = line.strip.split(/\s*[,;:]\s*|\s+/)
      min_values << values.shift.to_f
      max_values << values.shift.to_f
      decimals << values.shift.to_i
    end
  end
rescue StandardError => e
  ErrorHandling.message [e.message.red]
  ErrorHandling.clean_abort help_msg
end

n = min_values.size
if max_values.size != n || decimals.size != n
  ErrorHandling.message ['Unequal counts for min, max, and decimals'.red]
  ErrorHandling.clean_abort help_msg
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
                 ErrorHandling.message ['invalid number of factors'.red]
                 ErrorHandling.clean_abort help_msg
               end

lh_size ||= minimal_size

if lh_size < minimal_size
  ErrorHandling.clean_abort [
    "Latin hypercube size of #{lh_size} is too small for #{n} factors.".red
  ]
end

factor = Array.new(n) do |i|
  Scaler.new(min_values[i], max_values[i], decimals[i], lh_size)
end

design = NOLH::DESIGN_TABLE[lh_size]

num_columns = design[0].length
num_rotations ||= num_columns
if num_rotations > num_columns
  ErrorHandling.clean_abort [
    'Requested rotation exceeds number of columns in latin hypercube '.red +
    "(#{num_columns})".red
  ]
end

mid_range = lh_size / 2
num_rotations.times do |rotation_num|
  design.each_with_index do |dp, i|
    scaled_dp = dp.slice(0, n).map.with_index { |x, k| factor[k].scale(x) }
    puts scaled_dp.join "\t" unless rotation_num > 0 && i == mid_range
    design[i] = dp.rotate
  end
end
