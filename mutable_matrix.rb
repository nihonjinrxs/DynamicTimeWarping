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
end

class MutableVector < Vector
  public :"[]=", :set_element, :set_component
end

