require 'minitest/autorun'
require_relative '../lib/atv'

describe ATV do
  DATA_AS_TABLE = <<-TEXT
|-----------+--------------------+--------------|
| name      | dob                | predictable? |
|-----------+--------------------+--------------|
| Malcolm   | September 20, 2468 | false        |
| Reynolds  |                    |              |
|-----------+--------------------+--------------|
| Zoe       | February 15, 2484  |              |
| Washburne |                    |              |
|-----------+--------------------+--------------|
| Derrial   | null               | true         |
| Book      |                    |              |
|-----------+--------------------+--------------|

  TEXT

  EXPECTED = [
    ['Malcolm Reynolds', 'September 20, 2468', false],
    ['Zoe Washburne', 'February 15, 2484'],
    ['Derrial Book', nil, true]
  ]

  describe '#each' do
    before do
      @atv = ATV.new(StringIO.new(DATA_AS_TABLE))
    end

    it 'with a block it yields rows of data as CSV rows' do
      i = 0

      @atv.each do |row|
        row.fields.must_equal(EXPECTED[i])
        row[0].must_equal(EXPECTED[i][0])
        row['name'].must_equal(EXPECTED[i][0])
        row[1].must_equal(EXPECTED[i][1])
        row['dob'].must_equal(EXPECTED[i][1])
        row[2].must_equal(EXPECTED[i][2])
        row['predictable?'].must_equal(EXPECTED[i][2])
        i += 1
      end
      i.must_equal(3)
    end

    it 'without a block it returns an enumerator of data as CSV rows' do
      enum = @atv.enum_for
      enum.map(&:fields).must_equal(EXPECTED)
    end
  end

  describe "#headers" do
    it 'returns all the headers' do
      ATV.new(StringIO.new(DATA_AS_TABLE)).headers.must_equal(%w|name dob predictable?|)
    end
  end

  describe ".from_string(string)" do
    it 'initializes ATV with an IO object' do
      fussy = -> (io) { io.must_be_kind_of StringIO }

      ATV.stub :new, fussy do
        ATV.from_string(DATA_AS_TABLE)
      end
    end
  end
end
