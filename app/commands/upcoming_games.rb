# frozen_string_literal: true

module UpcomingGames
  DISCORD_BOT.command(
    :upcoming_games,
    permission_message: 'You must be an administrator to run this command',
    description: 'Post a list of the upcoming games to the current channel',
    usage: '!upcoming_games',
    help_available: true,
    max_args: 0
  ) do |_event|
    'Display fantasy football games here!'
  end
end
