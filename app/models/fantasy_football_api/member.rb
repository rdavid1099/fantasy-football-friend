# frozen_string_literal: true

module FantasyFootballApi
  class Member
    attr_reader :first_name, :last_name, :id
    attr_accessor :team

    def initialize(first_name:, last_name:, id:, team: nil)
      @first_name = first_name
      @last_name = last_name
      @id = id
      @team = team
    end
  end
end
