class Map
  attr_accessor :data

  def initialize(source_file:)
    @data = File.readlines(source_file).map(&:strip).map(&:chars)
  end

  def starting_location
    rows = data.size
    cols = data.first.size
    0.upto(rows - 1) do |row|
      0.upto(cols - 1) do |col|
        value = value_at(row, col)
        return value if value.char == 'S'
      end
    end
  end

  def value_at(row, col)
    # This is to prevent negative indexes from fetching data from the end of the array
    return nil if row.negative? || col.negative?

    begin
      Tile.new(row, col, @data.fetch(row).fetch(col), self)
    rescue StandardError => e
      nil
    end
  end
end
