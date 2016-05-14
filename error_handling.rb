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

  def self.prog_name
    $PROGRAM_NAME.split(%r{/|\\})[-1]
  end

  def self.cant_find(file_name)
    clean_abort [
      'ERROR: Cannot find file '.red + file_name.yellow, '',
      'Correct this by installing ' + file_name.yellow + ' into the same',
      'directory location as ' + prog_name.yellow + '.'
    ]
  end
end
