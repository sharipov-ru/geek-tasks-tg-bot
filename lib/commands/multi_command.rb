require './lib/commands/base_command'

module Commands
  class MultiCommand < BaseCommand
    attr_reader :commands, :executions

    def initialize(commands:)
      super()
      @commands = commands
    end

    def run_command
      @executions = []

      commands.each do |command|
        result = command.execute

        @executions << { command: command, result: result }
        break if result.failure?
      end

      @executions.all? { |e| e[:result].success? }
    end

    private

    def success
      SuccessResult.new(text: command_executions_result_string)
    end

    def failure
      FailureResult.new(text: command_executions_result_string)
    end

    def command_executions_result_string
      @executions.map { |e| e[:result].text }.join("\n")
    end
  end
end
