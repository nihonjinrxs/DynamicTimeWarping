# Dynamic Time Warping

# Implemented by Ryan B. Harvey
# October 29, 2012

# This computes the warping path and warping distance between a sample signal and a template signal.
# Implementation is based on a Java implementation of the same algorithm, used for validation.

require "./mutable_matrix"

class DynamicTimeWarping
  attr_reader :sample, :template, :warping_path, :warping_path_length_k, :warping_distance

  def initialize(sample, template)
    @sample = sample
    @template = template
    results = self.compute
    if results
      @warping_path = results[:warping_path]
      @warping_distance = results[:warping_distance]
    else
      puts "No results.  Please check your input data and try again."
    end
  end

  def self.add_new_setter_with_recompute(value_name)
    define_method("#{value_name}=".to_sym) do |value, recompute=true|
      instance_variable_set("@#{value_name}".to_sym, value)
      results = self.compute if recompute
      if results
        @warping_path = results[:warping_path]
        @warping_distance = results[:warping_distance]
      end
    end
  end

  add_new_setter_with_recompute :sample
  add_new_setter_with_recompute :template

  def distance_between(x, y)
    if x.kind_of?(Vector) and y.kind_of?(Vector) then
       (x - y).inner_product (x - y) # Leaving out Math.sqrt due to cost.
    else
      (x - y) * (x - y)
    end
  end

  def compute(options = {distance_function: method(:distance_between)})
    @sample_length_n, @template_length_m, @warping_path_length_k = @sample.count, @template.count, 1
    min_global_distance = 0.0

    distance = options[:distance_function] || method(:distance_between)

    #local_distances = MutableMatrix.build @sample_length_n, @template_length_m do |i, j|
    #  distance_between @sample[0, i], @template[0, j]
    #end

    # local_distances = @sample.compute_affinity @template do |x, y| distance.call x, y end
    local_distances = @sample.compute_affinity_multi @template do |x, y| distance.call x, y end

    global_distances = MutableMatrix.zero @sample_length_n, @template_length_m
    global_distances[0, 0] = local_distances[0, 0]

    (1..@sample_length_n-1).each do |i|
      global_distances[i, 0] = local_distances[i, 0] + global_distances[i-1, 0]
    end

    (1..@template_length_m-1).each do |j|
      global_distances[0, j] = local_distances[0, j] + global_distances[0, j-1]
    end

    (1..@sample_length_n-1).each do |i|
      (1..@template_length_m-1).each do |j|
        min_global_distance = [global_distances[i-1, j], global_distances[i-1, j-1], global_distances[i, j-1]].min
        global_distances[i, j] = min_global_distance + local_distances[i, j]
      end
    end

    #puts "min_global_distance before: #{min_global_distance.inspect}"
    #puts "global_distances before: #{global_distances.inspect}"
    min_global_distance = global_distances[@sample_length_n-1, @template_length_m-1]
    #puts "min_global_distance after: #{min_global_distance.inspect}"
    #puts "global_distances after: #{global_distances.inspect}"

    # Walk warping path backwards
    current_sample = @sample_length_n - 1
    current_template = @template_length_m - 1
    min_index = 1

    warping_path = MutableMatrix.zero @sample_length_n + @template_length_m, 2
    warping_path[@warping_path_length_k-1, 0] = current_sample
    warping_path[@warping_path_length_k-1, 1] = current_template

    while current_sample + current_template != 0 do
      if current_sample == 0
        current_template -= 1
      elsif current_template == 0
        current_sample -= 1
      else # both 0
        array = MutableMatrix[[ global_distances[current_sample - 1, current_template],
                             global_distances[current_sample, current_template - 1],
                             global_distances[current_sample - 1, current_template - 1] ]]
        min_index = array.index(array.min)[1]

        if min_index == 0
          current_sample -= 1
        elsif min_index == 1
          current_template -= 1
        elsif min_index == 2
          current_sample -= 1
          current_template -= 1
        end
      end # end else

      @warping_path_length_k += 1
      # puts "warping_path: #{warping_path.inspect}"
      warping_path[@warping_path_length_k - 1, 0] = current_sample
      warping_path[@warping_path_length_k - 1, 1] = current_template
    end # end while

    #puts "min_global_distance: #{min_global_distance.inspect}"
    #puts "@warping_path_length: #{@warping_path_length_k.inspect}"
    warping_distance = min_global_distance / @warping_path_length_k

    # Reverse path
    new_warping_path = MutableMatrix.build @warping_path_length_k, 2 do |i, j|
      warping_path[@warping_path_length_k-i-1, j]
    end
    warping_path = new_warping_path

    {warping_path: warping_path, warping_distance: warping_distance}
  end

  def testing_method
    puts "testing_method in DTW class"
  end

  def to_s
    string = "Warping Distance: #{@warping_distance.to_s}\nWarping Path: "
    (0..@warping_path_length_k-1).each do |i|
      string += "(#{@warping_path[i,0]},#{@warping_path[i,1]}) "
    end
    string
  end
end

# Only run this if the file is called directly
if __FILE__ == $0
  puts "OUTPUT: "
  puts ""

  signal1 = MutableMatrix[[2.1, 2.45, 3.673, 4.32, 2.05, 1.93, 5.67, 6.01]]
  signal2 = MutableMatrix[[1.5, 3.9, 4.1, 3.3]]
  signal3 = MutableMatrix[[1.5, 3.9, 4.1, 3.3, 2.0]]

  dtw = DynamicTimeWarping.new signal1, signal2
  puts "sample = #{signal1}"
  puts "template = #{signal2}"
  puts dtw
  puts ""

  dtw.template = signal3
  puts "sample = #{signal1}"
  puts "template = #{signal3}"
  puts dtw
  puts ""

  dtw.sample = signal2
  puts "sample = #{signal2}"
  puts "template = #{signal3}"
  puts dtw
  puts ""

  dtw.template = signal1
  puts "sample = #{signal2}"
  puts "template = #{signal1}"
  puts dtw
  puts ""

  dtw.sample = signal3
  puts "sample = #{signal3}"
  puts "template = #{signal1}"
  puts dtw
  puts ""

  dtw.template = signal2
  puts "sample = #{signal3}"
  puts "template = #{signal2}"
  puts dtw
  puts ""
end
