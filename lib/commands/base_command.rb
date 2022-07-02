module Commands
  class BaseCommand
    attr_reader :input

    def initialize(input)
      @input = input
    end

    def execute
      run_command ? success : failure
    rescue StandardError => e
      failure
    end

    def run_command
      raise NotImplementedError
    end

    private

    def success
      raise NotImplementedError
    end

    def failure
      raise NotImplementedError
    end
  end
end
