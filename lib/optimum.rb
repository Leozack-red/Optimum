# frozen_string_literal: true

require_relative "optimum/version"

module Optimum
  class Error < StandardError; end

  require_relative "optimum/vector_matrix_math/operation_vectors"
  require_relative "optimum/antagonistic_games/matrix_game"
  require_relative "optimum/cooperative_games/coalitions_coefficients"
  require_relative "optimum/cooperative_games/shapley_value"
end
