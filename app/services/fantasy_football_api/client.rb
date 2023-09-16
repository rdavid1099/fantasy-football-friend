# frozen_string_literal: true

module FantasyFootballApi
  class Client
    OPTIONS = {
      draft_detail: 'mDraftDetail',
      live_scoring: 'mLiveScoring',
      matchup_score: 'mMatchupScore',
      pending_transactions: 'mPendingTransactions',
      positional_ratings: 'mPositionalRatings',
      settings: 'mSettings',
      team: 'mTeam',
      modular: 'modular',
      nav: 'mNav'
    }.freeze

    attr_reader :url, :options, :league_id, :ffl_endpoint

    def initialize(*options)
      @url = 'https://fantasy.espn.com'
      @ffl_endpoint = '/apis/v3/games/ffl/seasons/2023/segments/0/leagues'
      @options = options.filter_map { |opt| OPTIONS[opt] }
      @league_id = '1380550185'
    end

    def call
      response
    end

    def response
      @response ||= FantasyFootballApi::Response.new(
        JSON.parse(raw_response.body).deep_transform_keys { |key| key.to_s.underscore.to_sym }
      )
    end

    private

    def raw_response
      @raw_response ||= conn.get("#{ffl_endpoint}/#{league_id}?#{params}") do |req|
        req.headers['Cookie'] = auth_cookies
      end
    end

    def conn
      @conn ||= Faraday.new(
        url:,
        headers: { 'Content-Type' => 'application/json' },
        request: { params_encoder: Faraday::FlatParamsEncoder }
      )
    end

    def params
      options.map { |option| "view=#{option}" }.join('&')
    end

    def auth_cookies
      { swid:, espn_s2: }.map { |key, value| "#{key}=#{value}" }.join('; ')
    end

    def swid
      "{#{Rails.application.credentials.dig(:espn, :swid)}}"
    end

    def espn_s2
      Rails.application.credentials.dig(:espn, :espn_s2)
    end
  end
end
