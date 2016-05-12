#!/usr/bin/env ruby -w

def err_msg(msg_array)
  STDERR.puts
  msg_array.each { |line| STDERR.puts line }
  STDERR.puts
end

def clean_abort(msg_array)
  err_msg(msg_array)
  exit
end
