# frozen_string_literal: true

RSpec.describe Optimum::VectorMatrixMath::OperationVectors do
  subject { Optimum::VectorMatrixMath::OperationVectors.new(vector1, vector2).inner_product }

  context "inner product of integer components of vector_matrix_math" do
    let(:vector1) { [1, 2] }
    let(:vector2) { [2, 3] }

    it "will product" do
      is_expected.to eq 8
    end
  end

  context "inner product of integer components of vector_matrix_math" do
    let(:vector1) { [1.4, 2] }
    let(:vector2) { [2, 3.9] }

    it "will product" do
      is_expected.to eq 10.6
    end
  end
end
