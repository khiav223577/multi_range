require 'multi_range/version'
require 'roulette-wheel-selection'

if not Array.method_defined?(:sum)
  warn "Please backports Array#sum method to use multi_range gem.\n" \
       "You can use backports gem and add the following lines to your program:\n" \
       "require 'backports/2.4.0/enumerable/sum'"
end

if not Range.method_defined?(:size)
  warn "Please backports Range#size method to use multi_range gem.\n" \
       "You can use backports gem and add the following lines to your program:\n" \
       "require 'backports/1.9.2/float/infinity'\n" \
       "require 'backports/2.0.0/range/size'"
end

class MultiRange
  attr_reader :ranges

  def initialize(ranges) # range 要由小到大排序，且各 range 不能重疊
    @ranges = ranges
  end

  def -(other)
    new_ranges = @ranges.clone

    return MultiRange.new(new_ranges) if new_ranges.empty?
    return MultiRange.new(new_ranges) if other.min > @ranges.last.max # 大於最大值
    return MultiRange.new(new_ranges) if other.max < @ranges.first.min # 小於最小值

    changed_size = 0
    @ranges.each_with_index do |range, idx|
      next if other.min > range.max # 大於這個 range
      break if other.max < range.min # 小於這個 range

      sub_range1 = range.min...other.min
      sub_range2 = (other.max + 1)..range.max

      sub_ranges = []
      sub_ranges << sub_range1 if sub_range1.any?
      sub_ranges << sub_range2 if sub_range2.any?

      new_ranges[idx + changed_size, 1] = sub_ranges
      changed_size += sub_ranges.size - 1
      break if other.max <= range.max # 沒有超過一個 range 的範圍
    end

    return MultiRange.new(new_ranges)
  end

  def sample
    range = RouletteWheelSelection.sample(@ranges.map{|s| [s, s.size] }.to_h)
    return nil if range == nil
    return rand(range)
  end

  def size
    @ranges.sum{|s| s.size }
  end

  def any?
    @ranges.any?
  end
end
