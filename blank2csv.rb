#!/usr/bin/env ruby -W0
# converts blank separated files to csv
$-i = '.orig'
ARGF.each { |line| puts line.strip.gsub(/\s+/, ',') }
