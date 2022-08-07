require 'telegram/bot'

require './lib/input'
require './lib/command_builder'
require './lib/exception_handler'

token = ENV['CMD_TASKS_TG_BOT_TOKEN']

include ExceptionHandler

Telegram::Bot::Client.run(token) do |bot|
  exception_handler do
    bot.listen do |message|
      input = Input.new(message)

      if input.valid?
        command = CommandBuilder.new(input).build

        result = command.execute

        bot.api.send_message(chat_id: message.chat.id, text: result.text)
      end
    end
  end
end
