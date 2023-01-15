# frozen_string_literal: true

RSpec.describe Optimum::CooperativeGames::CoalitionsCoefficients do
  subject { Optimum::CooperativeGames::CoalitionsCoefficients.new(number_players).call }

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
    let(:number_players) { Optimum::CooperativeGames::CoalitionsCoefficients::LIMIT_VALUE }

    it "raise exception" do
      expect { subject }.to raise_error(Optimum::Error)
    end
  end
end
