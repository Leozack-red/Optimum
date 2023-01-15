# frozen_string_literal: true

require "matrix"

module Optimum
  module VectorMatrixMath
    class ShellVector < Vector
      def self.create(components_vector)
        Vector.send(:new, components_vector)
      end
    end
  end
end
