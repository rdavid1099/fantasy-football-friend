# frozen_string_literal: true

class MessageService
  attr_reader :message, :channel_id

  def initialize(message:, channel_id:)
    @message = message
    @channel_id = channel_id
  end

  def call
    DISCORD_BOT.send_message(channel_id, message)
  end
end
