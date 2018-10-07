require "matrix"
require "pry"

# Still just levenshtein
class DamerauLevenshtein
  def initialize(string_a, string_b)
    @string_a = string_a
    @string_b = string_b
    @a_length = string_a.length
    @b_length = string_b.length
    @matrix   = mutable_matrix(a_length, b_length)
  end

  def distance
    return a_length if b_length.zero?
    return b_length if a_length.zero?

    (1..b_length).each do |j|
      (1..a_length).each do |i|
        matrix[i, j] = cost(i, j)
      end
    end

    matrix[a_length, b_length]
  end

  private

  def cost(i, j)
    if same_character?(i, j)
      matrix[i - 1, j - 1]
    else
      min_operation_value(i, j) + 1
    end
  end

  def same_character?(i, j)
    string_a[i - 1] == string_b[j - 1]
  end

  def min_operation_value(i, j)
    binding.pry
    [
      matrix[i - 1, j],    # Deletion:     Look left in the matrix. It costs + 1 more than matrix[i-1, j]
      matrix[i, j - 1],    # Insertion:    Look directly above the current entry in matrix. Costs +1.
      matrix[i - 1, j - 1] # Substitution: Completely substitute the character. This also costs +1 more  than matrix[j-1, i-1]
    ].min
  end

  def mutable_matrix(a_length, b_length)
    Matrix.build(a_length + 1, b_length + 1) do |row, col|
      if row.zero?
        col
      elsif col.zero?
        row
      else
        0
      end
    end
  end

  attr_reader :string_a, :string_b, :a_length, :b_length, :matrix
end

# Allow positions to be mutated
class Matrix
  def []=(i, j, value)
    @rows[i][j] = value
  end
end
