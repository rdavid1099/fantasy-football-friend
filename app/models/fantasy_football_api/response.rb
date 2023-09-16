# frozen_string_literal: true

module FantasyFootballApi
  class Response
    attr_reader :raw,
                :id,
                :game_id,
                :scoring_period_id,
                :season_id,
                :segment_id,
                :members,
                :teams

    def initialize(raw_response)
      @raw = raw_response
      process_raw_data
    end

    def schedule(current: false)
      return @schedule[raw.dig(:status, :current_matchup_period)] if current

      @schedule
    end

    private

    def process_raw_data
      set_ids
      set_members
      set_teams
      set_schedule
    end

    def set_ids
      @id = @raw[:id]
      @game_id = @raw[:game_id]
      @scoring_period_id = @raw[:scoring_period_id]
      @season_id = @raw[:season_id]
      @segment_id = @raw[:segment_id]
    end

    def set_members
      return if @members

      @members = @raw[:members].each_with_object({}) do |raw_member, result|
        result[raw_member[:id]] = FantasyFootballApi::Member.new(
          first_name: raw_member[:first_name],
          last_name: raw_member[:last_name],
          id: raw_member[:id]
        )
      end
    end

    def set_teams
      return if @teams

      @teams = @raw[:teams].each_with_object({}) do |raw_team, result|
        primary_owner = members[raw_team[:primary_owner]]
        team = FantasyFootballApi::Team.new(
          owner: primary_owner,
          name: raw_team[:name],
          id: raw_team[:id],
          record: "#{raw_team.dig(:record, :overall, :wins)}-#{raw_team.dig(:record, :overall, :losses)}"
        )
        primary_owner.team = team
        result[raw_team[:id]] = team
      end
    end

    def set_schedule
      return if @schedule

      current_matchup_period = raw.dig(:status, :current_matchup_period)

      @schedule = @raw[:schedule].each_with_object({}) do |raw_schedule, result|
        points_key = raw_schedule[:matchup_period_id] == current_matchup_period ? :total_points_live : :total_points
        away_team = teams[raw_schedule.dig(:away, :team_id)]
        home_team = teams[raw_schedule.dig(:home, :team_id)]

        matchup = FantasyFootballApi::Matchup.new(
          id: raw_schedule[:id],
          matchup_period_id: raw_schedule[:matchup_period_id],
          winner: raw_schedule[:winner],
          away_points: raw_schedule.dig(:away, points_key),
          away_team_id: away_team.id,
          home_points: raw_schedule.dig(:home, points_key),
          home_team_id: home_team.id
        )
        away_team.add_matchup(matchup)
        home_team.add_matchup(matchup)
        result[raw_schedule[:matchup_period_id]] ||= []
        result[raw_schedule[:matchup_period_id]].push(matchup)
      end
    end
  end
end
