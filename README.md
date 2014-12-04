# ATV: Ascii Table Values

ATV is a reader for data in ascii table format patterned after ruby's CSV library.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'atv'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install atv

## Usage

**Reading From a File**

```ruby
ATV.foreach("path/to/file.atv") do |row|
  # use row here...
end
```

**All At Once**

```ruby
arr_of_arrs = ATV.read("path/to/file.atv")
```

**Reading From a String**

```ruby
ATV.parse("|ATV|data|String|") do |row|
  # use row here...
end
```

## Contributing

1. Fork it ( https://github.com/IndieKelly/atv/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

