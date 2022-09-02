require './lib/commands/base_command'

module Commands
  class BaseInputCommand < BaseCommand
    attr_reader :input

    def initialize(input)
      @input = input
    end
  end
end
