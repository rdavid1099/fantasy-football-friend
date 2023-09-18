# frozen_string_literal: true

module Scoreboard
  DISCORD_BOT.command(
    :scoreboard,
    permission_message: 'You must be an administrator to run this command',
    description: 'Post a list of the upcoming games to the current channel',
    usage: '!upcoming_games',
    help_available: true,
    max_args: 0
  ) do |event|
    event << "🏈 It's your friendly neighborhood Fantasy Football Friend here!"
    event << "Let's take a look at this week's scoreboard.\n"

    fantasy_football_service = Messages::FantasyFootballService.new
    fantasy_football_service.matchup_scores.each do |matchup_score|
      event << matchup_score
    end

    event << "Here's a look at the top scoring teams this week."

    fantasy_football_service.sorted_team_scores.each_with_index do |score, index|
      event << "#{index + 1}. #{score[:name]} - #{score[:points]} #{'points'.pluralize(score[:points])}"
    end
    event << "\nGood luck 🎉"
  end
end
