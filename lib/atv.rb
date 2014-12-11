require "atv/version"
require 'csv'

class ATV
  include Enumerable

  def initialize(io)
    @io = io
    @io.readline
    @keys = split_table_line(@io.readline.chomp)
    @io.readline
  end

  def each
    line_data = []
    @io.each_line do |line|
      line.chomp!
      if line =~ /^\|\-/
        yield CSV::Row.new(@keys, line_data.transpose.map{|tokens| tokens.reject(&:empty?).join(' ')}) if !line_data.empty?
        line_data = []
        next
      end
      line_data << split_table_line(line)
    end
  end

  def self.from_string(string)
    self.new(StringIO.new(string))
  end

  protected

  def split_table_line(line)
    line[1..-1].split('|').map(&:strip)
  end
end
