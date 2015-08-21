#!/usr/bin/env ruby -w

# The "cross" method creates a large combinatorial
# design by crossing all combinations of individual
# smaller designs.  It uses a recursive back-end to
# do so because we don't know how many designs there
# may be in the input set.
#
# The method takes an array of arrays, where
# each sub-array contains a single component design,
# and kicks off the recursive build process.
def cross(array_of_arrays)
  solution = []
  recursive_build(array_of_arrays, 0, [], solution)
  solution
end

private

# The following should never be invoked by end users, it is
# only called by the cross method after suitable setup
def recursive_build(inputs, index, partial_soln, full_soln)
  if index >= inputs.size
    full_soln << partial_soln.join(',')
  else
    inputs[index].each do |line|
      recursive_build(inputs, index + 1, partial_soln + line, full_soln)
    end
  end
end

# The remainder is effectively the "main" for this script
if __FILE__ == $PROGRAM_NAME
  if ARGV.length > 1
    input_array = []
    ARGV.each do |filename|     # for each file given as a command-line arg...
      # open the file, read all the lines, and then for each line use
      # spaces, commas, colons, or semicolons to tokenize.
      input_array << File.open(filename).readlines.map do |line|
        line.strip.split(/[,:;]|\s+/)
      end
    end
    cross(input_array).each { |line| puts line }
  else
    STDERR.print "\n\t"
    STDERR.print "Must supply command-line arguments consisting of the names\n"
    STDERR.print "\tof two or more design files.\n\n"
  end
end
