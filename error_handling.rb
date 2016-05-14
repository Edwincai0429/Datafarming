#!/usr/bin/env ruby -w

# A module to process error messages in a standardized way
module ErrorHandling
  def self.message(msg_array)
    STDERR.puts
    msg_array.each { |line| STDERR.puts line }
    STDERR.puts
  end

  def self.clean_abort(msg_array)
    message(msg_array)
    exit
  end
end
