#!/usr/bin/env ruby -w
# Ruby script to convert end of line
$-i = '.orig'
ARGF.each { |line| puts line.split(/\r\n|\r/) }
