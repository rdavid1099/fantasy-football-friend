# frozen_string_literal: true

module UpcomingGames
  DISCORD_BOT.command(
    :upcoming_games,
    permission_message: 'You must be an administrator to run this command',
    description: 'Post a list of the upcoming games to the current channel',
    usage: '!upcoming_games',
    help_available: true,
    max_args: 0
  ) do |event|
    event << "🏈 It's your friendly neighborhood Fantasy Football Friend here!"
    event << "Let's take a look at your current match-ups.\n"

    response = FantasyFootballApi::Client.new(:matchup_score, :team).call
    teams = response.teams
    team_scores = []

    response.schedule(current: true).each do |matchup|
      matchup_scores = [
        { name: teams[matchup.away_team_id].name, points: matchup.away_points },
        { name: teams[matchup.home_team_id].name, points: matchup.home_points }
      ]
      team_scores << matchup_scores
      event << matchup_scores.map do |score|
        "**#{score[:name]}**: #{score[:points]} #{'points'.pluralize(score[:points])}"
      end.join(' vs ')
      event << ''
    end
    event << "\nHere's a look at the top scoring teams this week."
    team_scores.flatten.sort_by { |score| -score[:points] }.each_with_index do |score, index|
      event << "#{index + 1}. #{score[:name]} - #{score[:points]} #{'points'.pluralize(score[:points])}"
    end
    event << "\nGood luck 🎉"
  end
end
