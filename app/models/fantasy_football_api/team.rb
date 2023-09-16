# frozen_string_literal: true

module FantasyFootballApi
  class Team
    attr_reader :name, :id, :record, :matchups
    attr_accessor :owner

    def initialize(name:, id:, record:, owner: nil)
      @name = name
      @id = id
      @record = record
      @owner = owner
      @matchups = {}
    end

    def add_matchup(matchup)
      @matchups[matchup.matchup_period_id] = matchup
    end
  end
end
