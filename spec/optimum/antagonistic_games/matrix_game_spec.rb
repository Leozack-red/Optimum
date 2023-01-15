# frozen_string_literal: true

RSpec.describe Optimum::AntagonisticGames::MatrixGame do
  let(:strategies) { [[0, 23, 2, 423, 34, 4, 2], [55, 7, 10, 13, 434, 3434, 34], [5, 7, 10, 3, 44, 334, 34]] }

  context "with strategies and no report" do
    subject { Optimum::AntagonisticGames::MatrixGame.new(strategies).result }

    it "will find optimal strategies" do
      expect(subject[:first_strategy]).to match_array strategies[1]
      expect(subject[:second_strategy]).to match_array [2, 10, 10]
      expect(subject[:lower_value]).to eq 7
      expect(subject[:higher_value]).to eq 10
      expect(subject[:equilibrium]).to be_falsy
    end
  end

  context "with strategies for equilibrium and no report" do
    subject { Optimum::AntagonisticGames::MatrixGame.new(strategies).result }
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
    subject { Optimum::AntagonisticGames::MatrixGame.new(strategies).result(report = true) }

    it "will find optimal strategies and send a report" do
      expect(subject).to be_kind_of(String)
    end
  end
end
