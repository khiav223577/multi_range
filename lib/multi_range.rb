# frozen_string_literal: true

require 'multi_range/version'
require 'roulette-wheel-selection'

if not Range.method_defined?(:size)
  warn "Please backports Range#size method to use multi_range gem.\n" \
       "You can use backports gem and add the following lines to your program:\n" \
       "require 'backports/1.9.2/float/infinity'\n" \
       "require 'backports/2.0.0/range/size'"
end

if not Enumerable.method_defined?(:to_h)
  warn "Please backports Enumerable#to_h method to use multi_range gem.\n" \
       "You can use backports gem and add the following lines to your program:\n" \
       "require 'backports/2.1.0/enumerable/to_h'"
end

class MultiRange
  INDEX_WITH_DEFAULT = Object.new

  attr_reader :ranges

  def initialize(ranges)
    @ranges = ranges.map{|s| s.is_a?(Numeric) ? s..s : s }.sort_by(&:begin).freeze
    @is_float = @ranges.any?{|range| range.begin.is_a?(Float) || range.end.is_a?(Float) }
  end

  def merge_overlaps
    return MultiRange.new([]) if @ranges.size == 0

    new_ranges = []
    current_range = nil

    @ranges.each do |range|
      next current_range = range if current_range == nil
      next if range.end <= current_range.end

      if can_combine?(current_range, range)
        current_range = range.exclude_end? ? current_range.begin...range.end : current_range.begin..range.end
      else
        new_ranges << current_range
        current_range = range
      end
    end

    new_ranges << current_range
    return MultiRange.new(new_ranges)
  end

  def -(other)
    if other.is_a?(MultiRange)
      new_multi_range = dup
      other.ranges.each{|range| new_multi_range -= range }
      return new_multi_range
    end

    new_ranges = @ranges.dup

    return MultiRange.new(new_ranges) if new_ranges.empty?
    return MultiRange.new(new_ranges) if other.begin > @ranges.last.end # 大於最大值
    return MultiRange.new(new_ranges) if other.end < @ranges.first.begin # 小於最小值

    changed_size = 0
    @ranges.each_with_index do |range, idx|
      next if other.begin > range.end # 大於這個 range
      break if other.end < range.begin # 小於這個 range

      sub_range1 = range.begin...other.begin

      sub_range2_begin = if other.exclude_end?
                           other.end
                         else
                           other.end + (other.end.is_a?(Float) ? Float::EPSILON : 1)
                         end
      sub_range2 = range.exclude_end? ? sub_range2_begin...range.end : sub_range2_begin..range.end

      sub_ranges = []
      sub_ranges << sub_range1 if sub_range1.begin <= sub_range1.end
      sub_ranges << sub_range2 if sub_range2.begin <= sub_range2.end

      new_ranges[idx + changed_size, 1] = sub_ranges
      changed_size += sub_ranges.size - 1
      break if other.end <= range.end # 沒有超過一個 range 的範圍
    end

    return MultiRange.new(new_ranges)
  end

  def |(other)
    other_ranges = other.is_a?(MultiRange) ? other.ranges : [other]
    return MultiRange.new(@ranges + other_ranges).merge_overlaps
  end

  def overlaps?(other)
    multi_range = merge_overlaps
    return multi_range.ranges != (multi_range - other).ranges
  end

  def sample
    range = RouletteWheelSelection.sample(@ranges.map{|s| [s, s.size] }.to_h)
    return nil if range == nil
    return rand(range.max - range.min) + range.min
  end

  def size
    @ranges.inject(0){|sum, v| sum + v.size }
  end

  def any?
    @ranges.any?
  end

  def index_with(default = INDEX_WITH_DEFAULT)
    if block_given?
      fail ArgumentError, 'wrong number of arguments (given 1, expected 0)' if default != INDEX_WITH_DEFAULT
      return map{|s| [s, yield(s)] }.to_h
    end

    return to_enum(:index_with){ size } if default == INDEX_WITH_DEFAULT
    return map{|s| [s, default] }.to_h
  end

  def each
    return to_enum(:each){ size } if !block_given?

    ranges.each do |range|
      range.each{|s| yield(s) }
    end
  end

  def map
    return to_enum(:map){ size } if !block_given?
    return each.map{|s| yield(s) }
  end

  def to_a
    each.to_a
  end

  def min
    range = @ranges.first
    return range.min if range
  end

  def max
    range = @ranges.last
    return range.max if range
  end

  def contain_overlops?
    merge_overlaps.ranges != ranges
  end

  private

  # make sure that range1.begin <= range2.begin
  def can_combine?(range1, range2)
    return range1.end >= range2.begin if @is_float
    return range1.end + 1 >= range2.begin
  end
end
