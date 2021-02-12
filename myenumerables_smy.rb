
# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

# ENUMERABLE METHODS: Own implementation of enumerable methods behaviour
module Enumerable
  # Nothing
  def nothing
    yield nil
  end

  # sm_each: implement the enumerable 'each'
  # yields: 'value' to the block
  def sm_each
    # return to_enum(:sm_each) unless block_given?
    arr = self if instance_of?(Array)
    arr = to_a if instance_of?(Range)
    i = 0
    while i < arr.length
      yield(arr[i])
      i += 1
    end
    self
  end
  # TEST : -------------------------------
  # arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  # arr.sm_each do |value|
  #   p value
  # end

  # sm_each_with_index: implement the enumerable 'each_with_index'
  # yields: 'index' & 'value' to the block
  def sm_each_with_index
    return to_enum(:sm_each_with_index) unless block_given?

    i = 0
    while i < length
      yield(self[i], i)
      i += 1
    end
    self
  end
  # TEST : -------------------------------
  # arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  # arr.each_with_index do |value, index|
  #   p "Index: #{index+1} Value. #{value}"
  # end

  # sm_select: implement the enumerable 'select'
  # yields: Array of value selected on executing the block statements
  def sm_select
    return to_enum(:sm_select) unless block_given?

    temp = []
    sm_each { |x| temp.append(x) if yield(x) }
    temp
  end
  # TEST : -------------------------------
  # arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  # p arr.sm_select {|x| x > 5 }

  # sm_all?: implement the enumerable 'all?'
  # yields: returns False / TRUE if 'all' elements match conditional filter
  def sm_all?(default = nil)
    # Check the TYPE of argument received : block, class, array etc
    if block_given?
      sm_each { |enum| return false if yield(enum) == false }
    elsif default.is_a? Class
      sm_each { |enum| return false unless enum.is_a? default }
    elsif default.is_a? Regexp
      sm_each { |enum| return false unless default.match(enum) }
    elsif default.nil?
      sm_each { |enum| return false unless enum }
    else
      return "Case: didn't handle yet."
    end
    # after all cases are handled to return true implicitly
    true
  end
  # TEST : -------------------------------
  # arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  # p arr.sm_all? { |x| x < 11 }
  # arr2 = %w[ant bear cat]
  # p arr2.sm_all? { |word| word.length >= 3 }
  # arr3 = [1, 2, 3.14]
  # p arr3.sm_all?(String)
  # p arr3.sm_all?(Numeric)
  # arr4 = [nil, true, 99]
  # p arr4.sm_all?
  # p [].sm_all?
  # arr5 = %w[ant bear cat]
  # arr5 = %w[ant bat cat]
  # p arr5.sm_all?(/t/)

  # sm_any: implement the enumerable 'any?'
  # yields: returns False / TRUE if 'any' elements match conditional filter
  def sm_any?(default = nil)
    # Check the TYPE of argument received : block, class, array etc
    if block_given?
      sm_each { |enum| return true if yield(enum) == true }
    elsif default.is_a? Class
      sm_each { |enum| return true unless enum.is_a? default }
    elsif default.is_a? Regexp
      sm_each { |enum| return true if default.match(enum) }
    elsif default.nil?
      sm_each { |enum| return true unless enum }
    else
      return "Case: didn't handle yet."
    end
    # after all cases are handled to return false implicitly
    false
  end
  # TEST : -------------------------------
  # arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 'a']
  # p arr.sm_any? { |x| x == 5 }
  # p arr.sm_any? { |x| x.is_a? String }
  # arr2 = %w[pea ants bears cats]
  # p arr2.sm_any? { |word| word.length <= 3 }
  # arr3 = [1, 2, 3.14, 'a']
  # p arr3.sm_any?(String)
  # p arr3.sm_any?(Numeric)
  # arr4 = [nil, true, 99]
  # p arr4.sm_any?
  # p [].sm_any?
  # arr5 = %w[ant bears cat]
  # arr5 = %w[antz bat cat]
  # p arr5.sm_any?(/z/)

  # sm_none: implement the enumerable 'none?'
  # yields: returns False / TRUE if 'none of the' elements match conditional filter
  def sm_none?(default = nil)
    # Check the TYPE of argument received : block, class, array etc
    if block_given?
      sm_each { |enum| return false if yield(enum) == true }
    elsif default.is_a? Class
      sm_each { |enum| return false if enum.is_a? default }
    elsif default.is_a? Regexp
      sm_each { |enum| return false if default.match(enum) }
    elsif default.nil?
      sm_each { |enum| return false if enum }
    else
      return "Case: didn't handle yet."
    end
    # after all cases are handled to return false return true implicitly
    true
  end
  # TEST : -------------------------------
  # arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 'a']
  # # p arr.sm_none? { |x| x == 15 }
  # # p arr.sm_none? { |x| x.is_a? Float }
  # arr2 = %w[pea ants bears cats]
  # # p arr2.sm_none? { |word| word.length > 30 }
  # arr3 = [1.0, 2.0, 3.14]
  # p arr3.sm_none?(String)
  # p arr2.sm_none?(Numeric)
  # arr4 = [true, nil, false]
  # p arr4.sm_none?
  # p [].sm_none?
  # arr5 = %w[ant bears cat]
  # p arr5.sm_none?(/z/)

  # sm_count: implement the enumerable 'count'
  # yields: 'counts' matching items to the given block
  def sm_count
    return to_enum(:sm_count) unless block_given?

    count = 0
    sm_each { |enum| count += 1 if yield(enum) }
    count
  end
  # TEST : -------------------------------
  # arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  # p arr.sm_count {|x| x%3==0}

  # sm_map: implement the enumerable 'map'
  # yields: returns and ARRAY executing each item with given block
  def sm_map(proc = nil)
    return to_enum(:sm_map) unless block_given? || proc

    map_arr = []
    if proc
      sm_each { |enum| map_arr.append(proc.call(enum)) }
    else
      sm_each { |enum| map_arr.append(yield(enum)) }
    end

    map_arr
  end
  # TEST : -------------------------------
  # tarr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  # p (1..4).sm_map { |i| i*i }
  # p tarr.sm_map { |i| i*i }
  # square = Proc.new {|x| x**2 }
  # PROC will be executed & Block ignored
  # p (1..4).sm_map(square) {|y| y+1 }
  # Block will be executed
  # p (1..4).sm_map {|x| x**2 }

  # sm_inject: performs the actions like inject/reduce methods
  # yields: final total/string result of the BLOCK processed or Symbols
  def sm_inject(collect = nil)
    if block_given?
      sm_each do |enum|
        collect = collect.nil? ? enum : yield(collect, enum)
      end
    end
    collect
  end
  # TEST : ------------------------------
  # Below cases are handled, however outside the scope of the asignment
  # string = %w{ cat sheep bear }
  # p string.sm_inject { |memo, word| memo.length > word.length ? memo : word }
  # p arr.sm_inject { |result, element| result * element }
  # p (1..5).sm_inject(:+)
  # p arr.sm_inject(:+)
  # p arr.sm_inject(10, :+)
  # p arr.sm_inject { |memo, word| memo.length > word.length ? memo : word }
end

def multiply_els(arr)
  # Can Provide the BLOCK
  out = (arr.sm_inject { |result, element| (result * element) })
  p out
end
numbers = [2, 4, 5]
multiply_els(numbers)

# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
