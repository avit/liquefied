# Liquefied

Keep your value objects from setting into their final output format.

When formatting values in decorator objects we often want to have a default
format for their string output, but we also want to access the original values
to do arithmetic or other operations. Liquefied lets you have it both ways:

```
price = Liquefied.new(12.999) { |val| "$%.2f USD" % val }
price.zero? # false
price > 10  # true 
price + 1   # 13.999

price.to_s  # "$12.99 USD"
puts price  # $12.99 USD 
```

The method that invokes the block is a finalizer, which unwraps the liquefied
value to its output format. The default finalizer is `to_s`, which makes this
pattern helpful for implicit formatting in templates, so `<%= price %>`
outputs the formatted value.

The finalizer can be set to any other method you want. 

### Use with ActiveSupport Core Extensions

ActiveSupport extends core Ruby classes with a format option on `to_s`, which
enables a simplified usage pattern instead of specifying a block:

```
require 'active_support/core_ext'

date = Date.new(2016, 1, 1)

date.to_s         # "2016-01-01"
date.to_s(:long)  # "January 1, 2016"

date = Liquefied.new(date, :long)

date.to_s         # "January 1, 2016"
date.to_s(:short) # "Jan 1, 2016"
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'liquefied'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install liquefied

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/avit/liquefied.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

