# frozen_string_literal: true

require "matrix"

module Optimum
  module VectorMatrixMath
    class ShellMatrix
      def self.create(rows)
        Matrix.send(:new, rows)
      end
    end
  end
end
