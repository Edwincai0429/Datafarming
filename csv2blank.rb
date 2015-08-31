#!/usr/bin/env ruby -W0
# converts csv separated files to blank separated
$-i = '.orig'
ARGF.each { |line| puts line.strip.tr(',', ' ') }
