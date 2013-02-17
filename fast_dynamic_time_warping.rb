# Dynamic Time Warping

# Implemented by Ryan B. Harvey
# October 29, 2012

# This computes the warping path and warping distance between a sample signal and a template signal
# using the FastDTW algorithm for approximate calculation in O(n) time and space.
#
# Implementation of the FastDTW algorithm as described by Salvador and Chan.
#
# Stan Salvador and Philip Chan, FastDTW: Toward Accurate Dynamic Time Warping in Linear Time and
# Space, KDD Workshop on Mining Temporal and Sequential Data, pp. 70-80, 2004.
# http://www.cs.fit.edu/~pkc/papers/tdm04.pdf
#
# Stan Salvador and Philip Chan, Toward Accurate Dynamic Time Warping in Linear Time and Space,
# Intelligent Data Analysis, 11(5):561-580, 2007.
# http://www.cs.fit.edu/~pkc/papers/ida07.pdf
##

require "./dynamic_time_warping"

class FastDynamicTimeWarping < DynamicTimeWarping
  attr_reader :radius

  def initialize(sample, template, radius)
    @radius = radius
    super sample, template
  end

  add_new_setter_with_recompute :radius
  #def radius=(radius, recompute=true)
  #  @radius = radius
  #  results = self.compute if recompute
  #  if results
  #    @warping_path = results[:warping_path]
  #    @warping_distance = results[:warping_distance]
  #  end
  #end

  # Alias DynamicTimeWarping#compute for use within the overridden method
  alias :dtw_compute :compute

  def compute
    # FastDTW compute method
  end
end

if __FILE__ == $0
end