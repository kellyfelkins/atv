require 'minitest/autorun'
require_relative '../lib/atv'

describe ATV do
  describe 'with separators' do
    before do
      @data_as_table = <<-TEXT
|-----------+--------------------+--------------|
| name      | dob                | predictable? |
|-----------+--------------------+--------------|
| Malcolm   | September 20, 2468 | false        |
| Reynolds  |                    |              |
|-----------+--------------------+--------------|
| Zoe       | February 15, 2484  |              |
| Washburne |                    |              |
|-----------+--------------------+--------------|
# | Inara     | October 14, 2489   |              |
# | Sara      |                    |              |
# |-----------+--------------------+--------------|
| Derrial   | null               | true         |
| Book      |                    |              |
|-----------+--------------------+--------------|
      TEXT
      @expected = [
          ['Malcolm Reynolds', 'September 20, 2468', false],
          ['Zoe Washburne', 'February 15, 2484'],
          ['Derrial Book', nil, true]
      ]
    end

    describe '#each' do
      before do
        @atv = ATV.new(StringIO.new(@data_as_table))
      end

      it 'with a block it yields rows of data as CSV rows and ignores commented lines' do
        i = 0

        @atv.each do |row|
          row.fields.must_equal(@expected[i])
          row[0].must_equal(@expected[i][0])
          row['name'].must_equal(@expected[i][0])
          row[1].must_equal(@expected[i][1])
          row['dob'].must_equal(@expected[i][1])
          row[2].must_equal(@expected[i][2])
          row['predictable?'].must_equal(@expected[i][2])
          i += 1
        end
        i.must_equal(3)
      end

      it 'without a block it returns an enumerator of data as CSV rows' do
        enum = @atv.enum_for
        enum.map(&:fields).must_equal(@expected)
      end
    end

    describe "#headers" do
      it 'returns all the headers' do
        ATV.new(StringIO.new(@data_as_table)).headers.must_equal(%w|name dob predictable?|)
      end
    end

    describe ".from_string(string)" do
      it 'initializes ATV with an IO object' do
        fussy = -> (io) { io.must_be_kind_of StringIO }

        ATV.stub :new, fussy do
          ATV.from_string(@data_as_table)
        end
      end
    end
  end

  describe 'without separators' do
    describe '#each' do
      it 'with a block it yields rows of data as CSV rows' do
        data_as_table = <<-TEXT
|-----------+--------------------+--------------|
| name      | dob                | predictable? |
|-----------+--------------------+--------------|
| Malcolm   | September 20, 2468 | false        |
| Zoe       | February 15, 2484  |              |
| Derrial   | null               | true         |
|-----------+--------------------+--------------|
        TEXT

        expected = [
            ['Malcolm', 'September 20, 2468', false],
            ['Zoe', 'February 15, 2484'],
            ['Derrial', nil, true]
        ]
        @atv = ATV.new(StringIO.new(data_as_table))

        i = 0

        @atv.each do |row|
          row.fields.must_equal(expected[i])
          row[0].must_equal(expected[i][0])
          row['name'].must_equal(expected[i][0])
          row[1].must_equal(expected[i][1])
          row['dob'].must_equal(expected[i][1])
          row[2].must_equal(expected[i][2])
          row['predictable?'].must_equal(expected[i][2])
          i += 1
        end
        i.must_equal(3)
      end
    end
  end
end
