require './lib/user'

class Input
  def initialize(message)
    @message = message
  end

  def text
    @text ||= message.text
  end

  def chat_id
    @chat_id ||= message.chat.id
  end

  def user
    @user ||= User.new(message.from)
  end

  def valid?
    text.strip.length.positive?
  end

  private

  attr_reader :message
end
