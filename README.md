# MultiRange

[![Gem Version](https://img.shields.io/gem/v/multi_range.svg?style=flat)](http://rubygems.org/gems/multi_range)
[![Build Status](https://travis-ci.com/khiav223577/multi_range.svg?branch=master)](https://travis-ci.org/khiav223577/multi_range)
[![RubyGems](http://img.shields.io/gem/dt/multi_range.svg?style=flat)](http://rubygems.org/gems/multi_range)
[![Code Climate](https://codeclimate.com/github/khiav223577/multi_range/badges/gpa.svg)](https://codeclimate.com/github/khiav223577/multi_range)
[![Test Coverage](https://codeclimate.com/github/khiav223577/multi_range/badges/coverage.svg)](https://codeclimate.com/github/khiav223577/multi_range/coverage)

## Supports
 
- Ruby 2.0 ~ 2.7

For Ruby 1.8.x and 1.9.x, please use multi_range < 2.

## Installation

```ruby
gem 'multi_range'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install multi_range

## Usage

Allow you to manipulate a group of ranges. Such as merging overlapping ranges, doing ranges union and difference.

### Sample a number
```rb
multi_range = MultiRange.new([1..5, 10..12])
multi_range.sample
# => equals to [1, 2, 3, 4, 5, 10, 11, 12].sample
```

### Difference of ranges
```rb
multi_range = MultiRange.new([1..10])
multi_range -= 5..7
multi_range.ranges
# => [1...5, 8..10]
```

```rb
multi_range = MultiRange.new([1..10, 50..70, 80..100])
multi_range -= 5..85
multi_range.ranges
# => [1...5, 86..100]
```

```rb
multi_range = MultiRange.new([1..10, 50..70, 80..100])
multi_range -= MultiRange.new([5..60, 75..85])
multi_range.ranges
# => [1...5, 61..70, 86..100] 
```

### Union ranges

```rb
multi_range = MultiRange.new([1..5])
multi_range |= 3..8
multi_range.ranges
# => [1..8]
```

```rb
multi_range = MultiRange.new([1..5, 10..15, 20..25])
multi_range |= MultiRange.new([3..6, 14..22, 30])
multi_range.ranges
# => [1..6, 10..25, 30..30]
```

### Merge overlaps
```rb
multi_range = MultiRange.new([1, 2, 4..6, 7, 8..12])
multi_range.merge_overlaps.ranges
# => [1..2, 4..12]

multi_range = MultiRange.new([1.2..1.5, 1.7..1.9, 1.8..2.2])
multi_range.merge_overlaps.ranges
# => [1.2..1.5, 1.7..2.2]
```

### Check if it overlaps with the other

```rb
multi_range = MultiRange.new([1..5, 10..15, 20..25])
multi_range.overlaps?(7..8)
# => false

multi_range.overlaps?(3..8)
# => true

multi_range.overlaps?(7..12)
# => true
```

```rb
multi_range = MultiRange.new([1..5, 10..15, 20..25])
multi_range.overlaps?(MultiRange.new([6..8, 18..22]))
# => true
```


### Check if it contains overlaps

```rb
MultiRange.new([0..3, 5..10, 20..50]).contain_overlaps?
# => false

MultiRange.new([0...5, 5..10, 20..50]).contain_overlaps?
# => false

MultiRange.new([0..5, 5..10, 20..50]).contain_overlaps?
# => true

MultiRange.new([0...7, 5..10, 20..50]).contain_overlaps?
# => true
```

### Range-like interface

#### each
```rb
MultiRange.new([1..3, 6, 8..9]).each{|s| print s }
# => 123689
```

#### map
```rb
MultiRange.new([1..3, 6, 8..9]).map{|s| s * 2 }
# => [2, 4, 6, 12, 16, 18]
```

#### index_with
```rb
MultiRange.new([1..3, 6, 8..9]).index_with(true)
# => { 1 => true, 2 => true, 3 => true, 6 => true, 8 => true, 9 => true }
```

#### min
```rb
MultiRange.new([1..3, 6, 8..9]).min
# => 1
```

#### max
```rb
MultiRange.new([1..3, 6, 8..9]).max
# => 9
```

#### to_a
```rb
MultiRange.new([1..3, 6, 8..9]).to_a
# => [1, 2, 3, 6, 8, 9]
```


#### size
```rb
MultiRange.new([1..3, 6, 8..9]).size
# => 6
```

### Warning

The return value may be different when there are some overlapped ranges.
Call `merge_overlaps` if you want to merge overlapped ranges.

```rb
MultiRange.new([1..5, 3..6]).to_a
# => [1, 2, 3, 4, 5, 3, 4, 5, 6] 

MultiRange.new([1..5, 3..6]).merge_overlaps.to_a
# => [1, 2, 3, 4, 5, 6]
```

```rb
MultiRange.new([1..5, 3..6]).each{|s| print s }
# => 123453456

MultiRange.new([1..5, 3..6]).merge_overlaps.each{|s| print s }
# => 123456
```

```rb
MultiRange.new([1..5, 3..6]).map{|s| s * 2 }
# => [2, 4, 6, 8, 10, 6, 8, 10, 12] 

MultiRange.new([1..5, 3..6]).merge_overlaps.map{|s| s * 2 }
# => [2, 4, 6, 8, 10, 12] 
```

```rb
MultiRange.new([1..5, 3..6]).size
# => 9

MultiRange.new([1..5, 3..6]).merge_overlaps.size
# => 6
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/khiav223577/multi_range. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

