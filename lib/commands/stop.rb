require './lib/commands/base_input_command'

module Commands
  class Stop < BaseInputCommand
    MESSAGE = 'Bot stopped'.freeze

    def run_command
      true
    end

    private

    def success
      SuccessResult.new(text: MESSAGE)
    end
  end
end
