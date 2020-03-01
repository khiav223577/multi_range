# MultiRange

[![Gem Version](https://img.shields.io/gem/v/multi_range.svg?style=flat)](http://rubygems.org/gems/multi_range)
[![Build Status](https://travis-ci.org/khiav223577/multi_range.svg?branch=master)](https://travis-ci.org/khiav223577/multi_range)
[![RubyGems](http://img.shields.io/gem/dt/multi_range.svg?style=flat)](http://rubygems.org/gems/multi_range)
[![Code Climate](https://codeclimate.com/github/khiav223577/multi_range/badges/gpa.svg)](https://codeclimate.com/github/khiav223577/multi_range)
[![Test Coverage](https://codeclimate.com/github/khiav223577/multi_range/badges/coverage.svg)](https://codeclimate.com/github/khiav223577/multi_range/coverage)

## Supports
- Ruby 1.8 ~ 2.7

## Installation

Provides cross-rails methods for you to upgrade rails, backport features, create easy-to-maintain gems, and so on.

```ruby
gem 'multi_range'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install multi_range

## Usage

Allow you to manipulate a group of ranges.

### Sample a number
```rb
multi_range = MultiRange.new([1..5, 10..12])
multi_range.sample
# => equals to [1, 2, 3, 4, 5, 10, 11, 12].sample
```

### Range difference
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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/khiav223577/multi_range. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

