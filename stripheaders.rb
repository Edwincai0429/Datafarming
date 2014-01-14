#! /usr/bin/env ruby -w
#
# User supplies the name of one or more files to be "stripped"
# on the command-line.
#
# This script ignores the first line of each file.
# Subsequent lines of the file are copied to the new version.
#
# The operation saves each original input file with a suffix of
# ".orig" and then operates in-place on the specified files.

$-i = ".orig"   # specify backup suffix

oldfilename = ""

ARGF.each do |line|
  if ARGF.filename == oldfilename   # If it's an old file
    puts line                       # copy lines through.
  else                              # If it's a new file remember it
    oldfilename = ARGF.filename     # but don't copy the first line.
  end
end
