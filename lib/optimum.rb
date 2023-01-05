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
      p "The optimal strategy of first gamer: #{opt_strategy_first_gamer}"
      p "The optimal strategy of second gamer: #{opt_strategy_second_gamer}"
      if lower_value == higher_value
        "There is a situation of equilibrium: lower and higher values of game equal #{lower_value}"
      else
        p "Lower value: #{lower_value}"
        p "Higher value: #{higher_value}"
        "No situation of equilibrium"
      end
    end

    private

    def opt_strategy_first_gamer
      index = minimums_in_rows.index(lower_value)
      matrix.row(index)
    end

    def opt_strategy_second_gamer
      index = maximums_in_columns.index(higher_value)
      matrix.column(index)
    end

    def lower_value
      minimums_in_rows.max
    end

    def higher_value
      maximums_in_columns.min
    end

    def minimums_in_rows
      (0...count_rows).map { |number| minimum_in_row(number) }
    end

    def maximums_in_columns
      (0...count_columns).map { |number| maximum_in_column(number) }
    end

    def minimum_in_row(number)
      matrix.row(number).min
    end

    def maximum_in_column(number)
      matrix.column(number).max
    end
  end

  class CreateMatrix
    def self.create(rows)
      Matrix.send(:new, rows)
    end
  end
end
