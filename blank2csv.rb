#!/usr/bin/env ruby -w
# converts blank seperated files to csv
while line = gets do
  puts line.strip.split(/\s+/).join(",")
end
