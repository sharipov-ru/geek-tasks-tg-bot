require './lib/commands/base_input_command'

module Commands
  class SingleTaskAction < BaseInputCommand
    def task_token
      input.text
    end
  end
end
