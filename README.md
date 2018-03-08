# ATV: Ascii Table Values

ATV is a reader for data in ascii table format.
It allows you to read data formatted like this:

<pre>
|------------------+--------------------|
| name             | dob                |
|------------------+--------------------|
| Malcolm Reynolds | September 20, 2468 |
|------------------+--------------------|
| Zoe Washburne    | February 15, 2484  |
|------------------+--------------------|
</pre>

or, _without_ separators, like this:

<pre>
|------------------+--------------------|
| name             | dob                |
|------------------+--------------------|
| Malcolm Reynolds | September 20, 2468 |
| Zoe Washburne    | February 15, 2484  |
|------------------+--------------------|
</pre>

In [Ascii Tables For Clearer Testing][1] I discuss using ascii tables to improve comprehension
of software tests.

[1]: https://punctuatedproductivity.wordpress.com/2016/02/02/ascii-tables-for-clearer-testing/

This gem was originally created when I worked at Indiegogo. Indiegogo has graciously transferred ownership of the 
gem to me so that I can maintain it going forward. 

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

Rows are returned or yielded as [CSV::Row][2] objects.

[2]: http://www.ruby-doc.org/stdlib/libdoc/csv/rdoc/CSV/Row.html

<pre>
|-----------------------+------------------------------+-----------------------------------|
| **Ascii Table Value** | **Returned Value**           | **Notes**                         |
|-----------------------+------------------------------+-----------------------------------|
| Malcolm Reynolds      | "Malcolm Reynolds"           | Most values returned as string    |
|-----------------------+------------------------------+-----------------------------------|
| 123                   | "123"                        | including numbers                 |
|-----------------------+------------------------------+-----------------------------------|
| wrapped strings are   | "wrapped strings are folded" | Similar to yaml, wrapped          |
| folded                |                              | strings are folded with a single  |
|                       |                              | space replacing the new line      |
|-----------------------+------------------------------+-----------------------------------|
|                       | not available                | The CSV::Row object will not      |
|                       |                              | include columns with blank values |
|-----------------------+------------------------------+-----------------------------------|
| null                  | nil                          | null, true, and false are         |
|                       |                              | special values                    |
|-----------------------+------------------------------+-----------------------------------|
| true                  | true                         |                                   |
|-----------------------+------------------------------+-----------------------------------|
| false                 | false                        |                                   |
|-----------------------+------------------------------+-----------------------------------|
#| commented rows        | not included                 | As you would expect, commented    |
#|                       |                              | rows are not included             |
#|-----------------------+------------------------------+-----------------------------------|
</pre>

**Reading a String**

```ruby
atv = ATV.from_string(string)
atv.each do |row|
  # use row here...
end
```

**Reading from am IO object**

```ruby
atv = ATV.new(io)
atv.each do |row|
  # use row here...
end
```

More examples can be found in the Examples of Testing With ASCII Tables [repo](https://github.com/kellyfelkins/examples_of_testing_with_ascii_tables).

## Contributing

1. Fork it ( https://github.com/kellyfelkins/atv )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
