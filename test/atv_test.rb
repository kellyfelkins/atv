require 'minitest/autorun'
require_relative '../lib/atv'
require 'tempfile'

describe ATV do
  DATA_AS_TABLE = <<-TEXT
|------------------+--------------------|
| name             | dob                |
|------------------+--------------------|
| Malcolm Reynolds | September 20, 2468 |
|------------------+--------------------|
| Zoe Washburne    | February 15, 2484  |
|------------------+--------------------|
  TEXT

  EXPECTED = [
    ['Malcolm Reynolds', 'September 20, 2468'],
    ['Zoe Washburne', 'February 15, 2484']
  ]


  describe '.load(io)' do
    before do
      @io = StringIO.new(DATA_AS_TABLE)
    end

    it 'with a block it yields rows of data as CSV rows' do
      i = 0

      ATV.load(@io) do |row|
        row.fields.must_equal(EXPECTED[i])
        row[0].must_equal(EXPECTED[i][0])
        row['name'].must_equal(EXPECTED[i][0])
        row[1].must_equal(EXPECTED[i][1])
        row['dob'].must_equal(EXPECTED[i][1])
        i += 1
      end
      i.must_equal(2)
    end

    it 'without a block it returns all rows of data as CSV rows' do
      rows = ATV.load(@io)
      rows.map(&:fields).must_equal(EXPECTED)
    end
  end

  describe '.parse(data_as_string)' do
    it 'with a block it yields rows of data as CSV rows' do
      i = 0

      ATV.parse(DATA_AS_TABLE) do |row|
        row.fields.must_equal(EXPECTED[i])
        row[0].must_equal(EXPECTED[i][0])
        row['name'].must_equal(EXPECTED[i][0])
        row[1].must_equal(EXPECTED[i][1])
        row['dob'].must_equal(EXPECTED[i][1])
        i += 1
      end
      i.must_equal(2)
    end

    it 'without a block it returns all rows of data as CSV rows' do
      rows = ATV.parse(DATA_AS_TABLE)
      rows.map(&:fields).must_equal(EXPECTED)
    end
  end

  describe '.foreach(file_path)' do
    it 'it yields rows of data as CSV rows' do
      file = Tempfile.new('atv')
      begin
        file.write(DATA_AS_TABLE)
        file.rewind
        file.close

        i = 0
        ATV.foreach(file.path) do |row|
          row.fields.must_equal(EXPECTED[i])
          row[0].must_equal(EXPECTED[i][0])
          row['name'].must_equal(EXPECTED[i][0])
          row[1].must_equal(EXPECTED[i][1])
          row['dob'].must_equal(EXPECTED[i][1])
          i += 1
        end
        i.must_equal(2)

      ensure
        file.close
        file.unlink
      end
    end
  end

  describe '.read(file_path)' do
    it 'returns all rows of data as CSV rows' do
      file = Tempfile.new('atv')
      begin
        file.write(DATA_AS_TABLE)
        file.rewind
        file.close

        rows = ATV.read(file.path)
        rows.map(&:fields).must_equal(EXPECTED)

      ensure
        file.close
        file.unlink
      end
    end
  end
end
