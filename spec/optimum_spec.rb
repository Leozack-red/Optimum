# frozen_string_literal: true

require "byebug"

RSpec.describe Optimum do
  it "has a version number" do
    expect(Optimum::VERSION).not_to be nil
  end

  describe Optimum::OperationVectors do
    subject { Optimum::OperationVectors.new(vector1, vector2).inner_product }

    context "inner product of integer components of vector" do
      let(:vector1) { [1, 2] }
      let(:vector2) { [2, 3] }

      it "will product" do
        is_expected.to eq 8
      end
    end

    context "inner product of integer components of vector" do
      let(:vector1) { [1.4, 2] }
      let(:vector2) { [2, 3.9] }

      it "will product" do
        is_expected.to eq 10.6
      end
    end
  end

  describe Optimum::MatrixGame do
    subject { Optimum::MatrixGame.new(strategies).optimal_strateges }

    context "with strategies" do
      let(:strategies) { [[0, 23, 2, 423, 34, 4, 2], [55, 7, 10, 13, 434, 3434, 34],  [5, 7, 10, 3, 44, 334, 34]] }

      it "will find optimal strategies" do
        subject
      end
    end
  end
end
