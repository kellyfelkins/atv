require "atv/version"
require 'csv'

class ATV
  class << self
    def parse(data_as_table, &block)
      load(StringIO.new(data_as_table), &block)
    end

    def foreach(file_path, &block)
      File.open(file_path) { |io| load(io, &block) }
    end

    alias_method :read, :foreach

    def load(io, &block)
      io.readline
      key_line = io.readline.chomp
      rows = block_given? ? nil : []
      keys = split_table_line(key_line)

      io.each_line do |line|
        line.chomp!
        next if line =~ /^\|\-/
        values = split_table_line(line)

        row = CSV::Row.new(keys, values)
        if block_given?
          yield row
        else
          rows << row
        end
      end
      rows
    end

    protected

    def split_table_line(line)
      line[1..-1].split('|').map(&:strip)
    end
  end
end
