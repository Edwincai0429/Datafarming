#!/usr/bin/env ruby -w

require 'colorize'

String.disable_colorization false

require 'optparse'
require_relative 'error_handling'

help_msg = [
  'Run control to apply a designed experiment to a model with replication.', '',
  'This script assumes that the model uses command-line arguments to',
  'set factor values at run-time.', '',
  'Syntax:',
  "\n    ruby #{ErrorHandling.prog_name} [OPTIONS] ".yellow +
    "'CMD' DOE_FILE #REPS OUTPUT_FILE".yellow, '',
  "A vertical bar '|' indicates valid alternatives for OPTIONS.",
  'Valid OPTIONS are:', '',
  '  --help | -h | -? | ?'.green,
  "\tProduce this help message.",
  '  --print | -p'.green,
  "\tPrint generated commands rather than executing them,",
  "\tuseful for debugging.",
  '  --destructive | -d'.green,
  "\tOverwrite any prior contents in the output file.  Default",
  "\tbehavior is to append new results to an existing output file.", '',
  'Required arguments are:', '',
  "  'CMD'".green,
  "\tThe command to run the model.  " +
    'MUST be placed in single quotes'.red,
  "\tif the command contains any white space or special characters.",
  "\tExample: " + "'java MyModel.jar'".blue,
  '  DOE_FILE'.green,
  "\tThe name of a text file containing the experimental design",
  "\tto be used.  The design file should have one line per design",
  "\tpoint with factor settings separated by white space.  Factor",
  "\tsettings must be provided in the order expected by the model.",
  '  #REPS'.green,
  "\tAn integer specifying the number of times each design point",
  "\tshould be replicated.  All design points are completed before",
  "\tmoving to the next replication to minimize the risk of missing",
  "\tdesign points if the run gets interrupted for any reason.",
  '  OUTPUT_FILE'.green,
  "\tThe name of a text file to which all output will be written."
]

print_cmds = false # default is to run rather than print
destructive = false # default is non-destructive for output file
OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} [-h|--help] [filenames...[]"
  opts.on('-h', '-?', '--help') { ErrorHandling.clean_abort help_msg }
  opts.on('-p', '--print') { print_cmds = true }
  opts.on('-d', '--destructive') { destructive = true }
end.parse!

ErrorHandling.clean_abort help_msg if ARGV[0] == '?' || ARGV.length != 4

begin
  # What shall we run today?
  cmd = ARGV.shift
  # Suck in all the design points from the file specified as the next
  # argument, strip the whitespace, and put the results in an array
  design_pts = File.readlines(ARGV.shift).map(&:strip!)
  # How many times do we want to do this?
  reps = ARGV.shift.to_i
  # Where do the results go?
  output_file_name = ARGV.shift
  File.delete(output_file_name) if destructive && File.exist?(output_file_name)
  reps.times do
    design_pts.each do |design_pt|
      exe_line = "#{cmd} #{design_pt} >> #{output_file_name}"
      if print_cmds
        puts exe_line
      else
        result = `#{exe_line}`
        STDERR.puts result if result =~ /\S/
      end
    end
  end
rescue StandardError => e
  ErrorHandling.message [e.message.red]
  ErrorHandling.clean_abort help_msg
end
