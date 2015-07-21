#! /usr/bin/env ruby -w
#
# User supplies the name of a file to be "stripped" on the command-line.
#
# This script uses the first line of that file as a "header" template.
# Subsequent lines of the file are copied to the new version only if
# they do not match the header.
#
# The operation saves the original input file with a suffix of ".orig"
# and then operates in-place on the specified file.
#

$-i = '.orig'   # specify backup suffix

oldfilename = ''
header = ''

ARGF.each do |line|
  if ARGF.filename == oldfilename   # if it's an old file
    puts line unless line == header # copy non-header lines
  else                              # if it's a different file
    oldfilename = ARGF.filename     # make it the old file
    header = line                   # remember its header
    puts line                       # and copy it just this once
  end
end
