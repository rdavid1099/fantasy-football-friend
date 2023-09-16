# frozen_string_literal: true

module Ping
  DISCORD_BOT.command(:ping) do |_event, *args|
    "PONG! **#{args.join(' ')}**"
  end
end
