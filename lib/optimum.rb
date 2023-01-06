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

    def result(report = false)
      return report_message if report

      hash_result
    end

    private

    def hash_result
      {
        first_strategy: opt_strategy(:first),
        second_strategy: opt_strategy(:second),
        lower_value: lower_value,
        higher_value: higher_value,
        equilibrium: lower_value == higher_value
      }
    end

    def report_message
      message = "The optimal strategy of first gamer: #{opt_strategy(:first)}. The optimal strategy of second gamer: #{opt_strategy(:second)}"
      if lower_value == higher_value
        message + "There is a situation of equilibrium: lower and higher values of game equal #{lower_value}"
      else
        message + "Lower value: #{lower_value}. Higher value: #{higher_value}. No situation of equilibrium"
      end
    end

    def opt_strategy(gamer_position)
      case gamer_position
      when :first
        index = vector_search(:row).index(lower_value)
        matrix.row(index).to_a
      when :second
        index = vector_search(:column).index(higher_value)
        matrix.column(index).to_a
      end
    end

    def lower_value
      vector_search(:row).max
    end

    def higher_value
      vector_search(:column).min
    end

    def vector_search(vector)
      case vector
      when :row
        (0...count_rows).map { |number| extremum_search(number, :min) }
      when :column
        (0...count_columns).map { |number| extremum_search(number, :max) }
      end
    end

    def extremum_search(number, direction)
      case direction
      when :min
        matrix.row(number).min
      when :max
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
