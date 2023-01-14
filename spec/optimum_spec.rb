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
    let(:strategies) { [[0, 23, 2, 423, 34, 4, 2], [55, 7, 10, 13, 434, 3434, 34], [5, 7, 10, 3, 44, 334, 34]] }

    context "with strategies and no report" do
      subject { Optimum::MatrixGame.new(strategies).result }

      it "will find optimal strategies" do
        expect(subject[:first_strategy]).to match_array strategies[1]
        expect(subject[:second_strategy]).to match_array [2, 10, 10]
        expect(subject[:lower_value]).to eq 7
        expect(subject[:higher_value]).to eq 10
        expect(subject[:equilibrium]).to be_falsy
      end
    end

    context "with strategies for equilibrium and no report" do
      subject { Optimum::MatrixGame.new(strategies).result }
      let(:strategies) { [[2, 1], [2, 0]] }

      it "will find optimal strategies" do
        expect(subject[:first_strategy]).to match_array strategies[0]
        expect(subject[:second_strategy]).to match_array [1, 0]
        expect(subject[:lower_value]).to eq 1
        expect(subject[:higher_value]).to eq 1
        expect(subject[:equilibrium]).to be_truthy
      end
    end

    context "with strategies and report" do
      subject { Optimum::MatrixGame.new(strategies).result(report = true) }

      it "will find optimal strategies and send a report" do
        expect(subject).to be_kind_of(String)
      end
    end
  end

  describe Optimum::CoalitionsCoefficients do
    subject { Optimum::CoalitionsCoefficients.new(number_players).call }

    context "with 3 number players" do
      let(:number_players) { 3 }

      it "return array of coefficients for coalitions" do
        expect(subject).to match_array([1.0 / 3.0, 1.0 / 6.0, 1.0 / 3.0])
      end
    end

    context "with 4 number players" do
      let(:number_players) { 4 }

      it "return array of coefficients for coalitions" do
        expect(subject).to match_array([1.0 / 4.0, 1.0 / 12.0, 1.0 / 12.0, 1.0 / 4.0])
      end
    end

    context "with limit value" do
      let(:number_players) { Optimum::CoalitionsCoefficients::LIMIT_VALUE }

      it "raise exception" do
        expect { subject }.to raise_error(Optimum::Error)
      end
    end
  end

  describe Optimum::ShapleyValue do
    subject { Optimum::ShapleyValue.new(coalitions, number_players).resolve }

    context "with 3-players game and integers values of costs" do
      let(:number_players) { 3 }
      let(:coalitions) do
        {
          A: 0,
          B: 0,
          C: 0,
          AB: 1,
          AC: 1,
          ABC: 1
        }
      end

      it "return Shapley Value" do
        expect(subject).to match_array([(2.0 / 3.0).round(3), (1.0 / 6.0).round(3), (1.0 / 6.0).round(3)])
      end
    end

    context "with 3-players game and float values of gain" do
      let(:number_players) { 3 }
      let(:coalitions) do
        {
          a: 0.0,
          b: 0.0,
          c: 0.0,
          ab: 1.0,
          ac: 1.0,
          abc: 1.0
        }
      end

      it "return Shapley Value" do
        expect(subject).to match_array([(2.0 / 3.0).round(3), (1.0 / 6.0).round(3), (1.0 / 6.0).round(3)])
      end
    end

    context "with 3-players game and more then 10 gain" do
      let(:number_players) { 3 }
      let(:coalitions) do
        {
          a: 5000,
          b: 5000,
          c: 0,
          ab: 7500,
          ac: 7500,
          bc: 5000,
          abc: 10_000
        }
      end

      it "return Shapley Value" do
        expect(subject).to match_array([5000, 3750, 1250])
      end
    end

    context "with missing of number of players will return error" do
      let(:number_players) { nil }
      let(:coalitions) do
        {
          a: 5000,
          b: 5000,
          c: 0,
          ab: 7500,
          ac: 7500,
          bc: 5000,
          abc: 10_000
        }
      end

      it "raise exception" do
        expect { subject }.to raise_error(Optimum::Error)
      end
    end

    context "with missing of coalitions of players will return error" do
      let(:number_players) { 3 }
      let(:coalitions) { nil }

      it "raise exception" do
        expect { subject }.to raise_error(Optimum::Error)
      end
    end
  end
end
