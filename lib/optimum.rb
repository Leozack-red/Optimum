# frozen_string_literal: true

require_relative "optimum/version"
require "matrix"

module Optimum
  class Error < StandardError; end

  class OperationVectors
    attr_accessor :vector1, :vector2

    def initialize(vector1, vector2)
      @vector1 = Vector.create(vector1)
      @vector2 = Vector.create(vector2)
    end

    def inner_product
      vector1.inner_product(vector2)
    end
  end

  class Vector < Vector
    def self.create(components_vector)
      Vector.send(:new, components_vector)
    end
  end

  class MatrixGame
    attr_accessor :matrix, :count_rows, :count_columns
    def initialize(rows)
      @matrix = CreateMatrix.create(rows)
      @count_rows = rows.size
      @count_columns = rows.first.size
    end

    def optimal_strateges
      p "The optimal strategy of first gamer: #{opt_strategy(:first)}"
      p "The optimal strategy of second gamer: #{opt_strategy(:second)}"
      if lower_value == higher_value
        "There is a situation of equilibrium: lower and higher values of game equal #{lower_value}"
      else
        p "Lower value: #{lower_value}"
        p "Higher value: #{higher_value}"
        "No situation of equilibrium"
      end
    end

    private

    def opt_strategy(gamer_position)
      if gamer_position == :first
        index = vector_search(:row).index(lower_value)
        matrix.row(index)
      elsif gamer_position == :second
        index = vector_search(:column).index(higher_value)
        matrix.column(index)
      end
    end

    def lower_value
      vector_search(:row).max
    end

    def higher_value
      vector_search(:column).min
    end

    def vector_search(vector)
      if vector == :row
        (0...count_rows).map { |number| extremum_search(number, :min) }
      elsif vector == :column
        (0...count_columns).map { |number| extremum_search(number, :max) }
      end
    end

    def extremum_search(number, direction)
      if direction == :min
        matrix.row(number).min
      elsif direction == :max
        matrix.column(number).max
      end
    end
  end

  class CreateMatrix
    def self.create(rows)
      Matrix.send(:new, rows)
    end
  end
end
