#!/usr/bin/env ruby -w
# converts blank seperated files to csv
while line = gets
  puts line.strip.split(/\s+/).join(',')
end
