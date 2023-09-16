# frozen_string_literal: true

require 'discordrb'

CHANNEL_ID = Rails.application.credentials.dig(:discord, :channel_id)

DISCORD_BOT = Discordrb::Commands::CommandBot.new(
  token: Rails.application.credentials.dig(:discord, :token),
  client_id: Rails.application.credentials.dig(:discord, :client_id),
  prefix: '!'
)
Dir["#{Rails.root}/app/commands/*.rb"].each { |file| require file }
DISCORD_BOT.run(true)
