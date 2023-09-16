# frozen_string_literal: true

module FantasyFootballApi
  class Matchup
    attr_reader :id, :matchup_period_id, :winner, :away_points, :home_points, :away_team_id, :home_team_id

    def initialize(id:, matchup_period_id:, winner:, away_points:, home_points:, away_team_id:, home_team_id:)
      @id = id
      @matchup_period_id = matchup_period_id
      @winner = winner
      @away_points = away_points
      @home_points = home_points
      @away_team_id = away_team_id
      @home_team_id = home_team_id
    end
  end
end
