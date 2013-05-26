# encoding: utf-8
#
# = mutable_matrix.rb
#
# Implements the MutableMatrix and MutableVector classes, extending the
# Matrix and Vector classes to be mutable.
#
# See classes Matrix and Vector for documentation of the original classes.
#
# NOTE: Using a local copy of the following files, as patched by the current
# maintainer of the library (Marc-André Lafortune) until released with the
# MRI Ruby 1.9.4 release. (http://bugs.ruby-lang.org/issues/5307)
#   * ./matrix.rb
#   * ./matrix/eigenvalue_decomposition.rb
#   * ./matrix/lup_decomposition.rb
#
# Current Maintainer:: Ryan B. Harvey
# Original Author:: Ryan B. Harvey
##

require "./matrix"

class MutableMatrix < Matrix
  public :"[]=", :set_element, :set_component

  def compute_affinity(matrix_1d, &distance_metric)
    MutableMatrix.build row_size, matrix_1d.row_size do |i, j|
      distance_metric.call self[0, i], @matrix_1d[0, j]
    end
  end

  def compute_affinity_multi(matrix, &distance_metric)
    obs = self.column_vectors
    matrix_obs = matrix.column_vectors
    result = MutableMatrix.build column_size, matrix.column_size do |i, j|
      distance_metric.call obs[i], matrix_obs[j]
    end
    result
  end
end

class MutableVector < Vector
  public :"[]=", :set_element, :set_component
end

