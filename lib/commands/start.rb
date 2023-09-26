require './lib/commands/base_input_command'

module Commands
  class Start < BaseInputCommand
    MESSAGE = 'Bot started'.freeze

    def run_command
      true
    end

    private

    def success
      SuccessResult.new(text: MESSAGE)
    end
  end
end
