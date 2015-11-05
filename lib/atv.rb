require "atv/version"
require 'csv'

class ATV
  include Enumerable

  SUBSTITUTIONS = {
    'true' => true,
    'false' => false,
    'null' => nil
  }

  attr_reader :headers
  
  def initialize(io)
    @io = io
    @has_separators = has_separators?(@io)
    @io.rewind
    @io.readline
    @headers = split_table_line(@io.readline.chomp)
    @io.readline
  end

  def each
    line_data = []
    @io.each_line do |line|
      line.chomp!
      if (!@has_separators && !line_data.empty?) || line =~ /^\|\-/
        csv_row = CSV::Row.new(@headers, line_data.
          transpose.
          map { |tokens| tokens.reject(&:empty?).join(' ') }.
          map { |token| SUBSTITUTIONS.has_key?(token) ? SUBSTITUTIONS[token] : token }
        ).delete_if {|k, v| v == ''}
        yield csv_row if csv_row.size > 0
        line_data = []
        next if @has_separators
      end
      line_data << split_table_line(line)
    end
  end

  def self.from_string(string)
    self.new(StringIO.new(string))
  end

  protected

  def split_table_line(line)
    return [] if line.empty?
    line[1..-1].split('|').map(&:strip)
  end

  def has_separators?(io)
    @io.readline
    @io.readline
    @io.readline
    separator_count = 0
    @io.each_line do |line|
      if line =~ /^\|\-/
        separator_count += 1
        return true if separator_count > 1
      end
    end
    false
  end
end
