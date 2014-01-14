#!/usr/bin/env ruby -w
# Ruby script to merge csv files
allfiles = []
labels = ARGV.join(",")
ARGV.each do |fname|
  allfiles << File.readlines(fname).collect {|line| line.strip!}
end
puts labels
allfiles.transpose.each {|row| puts row.join(",")}
