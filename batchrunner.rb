#!/usr/bin/env ruby -w

require 'colorize'

String.disable_colorization false

require 'optparse'
require_relative 'error_handling'

help_msg = [
  'Run a model interactively with replication.', '',
  'Prompts the user interactively for a model/program to be run,',
  'parameter values to use on the model command-line, and desired',
  'number of replications.  The model is run the specified number',
  'of times with the given arguments.  Separate output files are',
  'created for each run of the model.', '',
  'Syntax:',
  "\n\truby #{ErrorHandling.prog_name} [--help] ".yellow +
    '[--outfile fname]'.yellow, '',
  "Arguments in square brackets are optional.  A vertical bar '|'",
  'indicates valid alternatives for invoking the option.', '',
  '  --help | -h | -? | ?'.green,
  "\tProduce this help message.",
  '  --outfile fname | -o fname'.green,
  "\tSpecify a specific prefix for output file names, defaults to 'outfile'."
]

outfile_name = 'outfile'
OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} [OPTIONS]"
  opts.on('-h', '-?', '--help') { ErrorHandling.clean_abort help_msg }
  opts.on('-o', '--outfile fname') { |fname| outfile_name = fname }
end.parse!

ErrorHandling.clean_abort help_msg if ARGV[0] == '?'

cmd = (STDERR.print 'Enter command: '; gets.strip)
params = (STDERR.print 'Enter parameters: '; gets.strip)
num_runs = (STDERR.print 'Enter # runs: '; gets).to_i

(1..num_runs).each do |run|
  STDERR.print "run #{run}:",
               `#{cmd} #{params} > #{outfile_name}-#{'%05d' % run}.csv`, "\n"
end
