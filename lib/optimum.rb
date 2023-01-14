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

  class ShapleyValue
    attr_accessor :coalitions, :number_players, :coefficients, :round

    DEFAULT_VALUE_OF_COALITION = 0
    def initialize(coalitions, number_players, round = 3)
      @coalitions = coalitions
      @number_players = number_players
      @coefficients = Optimum::CoalitionsCoefficients.new(number_players).call
      @round = round
    end

    def resolve
      validate_input
      validate_coefficients
      validate_grand_coalition
      vector if validate_vector
    end

    private

    def vector
      vector = (0..number_players - 1).map do |number|
        name_player = singleton_coalitions[number].first
        coalitions_with_player = coalitions_with_player(name_player)

        shapley_value_for_one_player(name_player, coalitions_with_player)
      end

      sum_subarray(vector)
    end

    def shapley_value_for_one_player(name_player, coalitions_with_player)
      coalitions_with_player.map do |coalition, value|
        if coalition.size == 1
          coefficients[0] * value
        else
          coefficients[coalition.size - 1] * (value - value_coalition_without_player(coalition, name_player))
        end
      end.flatten
    end

    def sum_subarray(vector)
      vector.map { |array| array.sum.round(round) }
    end

    def value_coalition_without_player(coalition, name_player)
      value = coalitions[coalition.to_s.delete(name_player.to_s).to_sym]
      return value unless value.nil?

      DEFAULT_VALUE_OF_COALITION
    end

    def singleton_coalitions
      coalitions.select { |key, _value| key.size == 1 }.to_a
    end

    def coalitions_with_player(name_player)
      coalitions.select { |key, _value| key.to_s.include?(name_player.to_s) }
    end

    def validate_coefficients
      raise Error, "Not find coefficients" if coefficients.empty?
    end

    def validate_grand_coalition
      return if value_grand_coalition

      raise Error,
            "Not find grand coalition or no several singletons coalitions is defined"
    end

    def validate_input
      raise Error, "Not find coalitions" if coalitions.empty?
      raise Error, "Not find number of players" if number_players.nil?
    end

    def validate_vector
      if vector.sum.round(2) != value_grand_coalition.round(2)
        raise Error,
              "Sum values of vector is not equal value of grand coalition"
      end

      true
    end

    def value_grand_coalition
      names_singleton_coalitions = singleton_coalitions.map(&:first)
      coalitions[names_singleton_coalitions.join("").to_sym]
    end
  end

  class CoalitionsCoefficients
    attr_accessor :number_players

    LIMIT_VALUE = 171

    def initialize(number_players)
      @number_players = number_players.to_f
    end

    def call
      validate_number
      coefficients if number_players == coefficients.size
    end

    private

    def coefficients
      (0...number_players).map do |coalition_power|
        numerator = factorial(coalition_power) * factorial(number_players - coalition_power - 1)
        numerator.to_f / factorial(number_players)
      end
    end

    def factorial(n)
      (1..n).inject(1, :*)
    end

    def validate_number
      return unless number_players >= LIMIT_VALUE

      raise Error,
            "The players is #{LIMIT_VALUE} or more. You should reduce the number of players"
    end
  end
end
