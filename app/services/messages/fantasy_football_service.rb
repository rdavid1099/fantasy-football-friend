# frozen_string_literal: true

module Messages
  class FantasyFootballService
    attr_reader :response

    def initialize
      @response = FantasyFootballApi::Client.new(:matchup_score, :team).call
    end

    def matchup_scores
      current_schedule.map do |matchup|
        result = matchup_team_scores(matchup:).map do |score|
          "**#{score[:name]}**: #{score[:points]} #{'points'.pluralize(score[:points])}"
        end.join(' vs ')

        "#{result}\n"
      end
    end

    def sorted_team_scores
      current_schedule.map { |matchup| matchup_team_scores(matchup:) }.flatten.sort_by { |score| -score[:points] }
    end

    def matchup_team_scores(matchup:)
      [
        { name: teams[matchup.away_team_id].name, points: matchup.away_points },
        { name: teams[matchup.home_team_id].name, points: matchup.home_points }
      ]
    end

    def teams
      @teams ||= response.teams
    end

    def current_schedule
      @current_schedule ||= response.schedule(current: true)
    end
  end
end
