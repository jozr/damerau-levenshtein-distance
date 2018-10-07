require "matrix"
require "pry"

# Allow positions to be mutated
class Matrix
  def []=(i, j, value)
    @rows[i][j] = value
  end
end

# Still just levenshtein
class DamerauLevenshtein
  def initialize(string_a, string_b)
    @string_a = string_a
    @string_b = string_b
    @a_length = string_a.length
    @b_length = string_b.length
    @matrix   = Matrix.build(a_length + 1, b_length + 1) do |row, col| # extract to own method
      if row.zero?
        col
      elsif col.zero?
        row
      else
        0
      end
    end
  end

  def distance
    return a_length if b_length.zero?
    return b_length if a_length.zero?

    (1..b_length).each do |j|
      (1..a_length).each do |i|
        matrix[i, j] = costs_for_step(i, j)
      end
      end

    matrix[a_length, b_length]
  end

  private

  attr_reader :string_a, :string_b, :a_length, :b_length, :matrix

  def same_character_for_both_words_is_added?(i, j)
    string_a[i - 1] == string_b[j - 1]
  end

  def obtain_minimal_value_from_neighbors(i, j)
    [
      matrix[i - 1, j],    # Look left in the matrix. This would be a "deletion". It costs + 1 more than matrix[i-1, j]]
      matrix[i, j - 1],    # Look directly above the current entry in matrix. This would correspond to an insertion which costs +1 additionally
      matrix[i - 1, j - 1] # Completely substitute the character, this also costs +1 more  than matrix[j-1, i-1]
    ].min
  end

  def costs_for_step(i, j)
    if same_character_for_both_words_is_added?(i, j)
      matrix[i - 1, j - 1]
    else
      obtain_minimal_value_from_neighbors(i, j) + 1
    end
  end
end
