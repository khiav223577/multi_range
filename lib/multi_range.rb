require 'multi_range/version'
require 'roulette-wheel-selection'

class MultiRange
  def initialize(ranges) # range 要由小到大排序，且各 range 不能重疊
    @ranges = ranges
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
