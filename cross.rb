#!/usr/bin/env ruby -w

# The "Cross" class creates a large combinatorial
# design by crossing all combinations of individual
# smaller designs.  It uses recursion to do so
# because we don't know how many designs there may
# be in the input set.
class Cross
  # create the solution set and a getter method for it.
  attr_reader :solution

  # the Constructor takes an array of arrays, where
  # each sub-array contains a single component design,
  # and kicks off the recursive build process.
  def initialize(array_of_arrays)
    @allfiles = array_of_arrays
    @solution = []
    recursive_build(0, '')
  end

  private

  # the following should never be invoked by end users,
  # it is only called by the constructor after suitable setup
  def recursive_build(index, partial_solution)
    if index < @allfiles.size - 1
      @allfiles[index].each do |line|
        recursive_build(index + 1, partial_solution + line + ',')
      end
    else
      @allfiles[index].each { |line| @solution << partial_solution + line }
    end
  end
end

# The remainder is effectively the "main" for this script
if __FILE__ == $PROGRAM_NAME
  if ARGV.length > 1
    input_array = []
    ARGV.each do |filename|     # for each file given as a command-line arg...
      # open the file, read all the lines, and then for each line use
      # spaces, commas, colons, or semicolons to tokenize, then rejoin
      # with commas (i.e., standardize on CSV regardless of what the
      # original token separator was).  Take the resulting line and
      # append it to input_array
      input_array << File.open(filename).readlines.collect do |line|
        line.strip.split(/[,:;]|\s+/).join(',')
      end
    end

    c = Cross.new(input_array)
    c.solution.each { |line| puts line }
  else
    STDERR.print "\n\t"
    STDERR.print "Must supply command-line arguments consisting of the names\n"
    STDERR.print "\tof two or more design files.\n\n"
  end
end
