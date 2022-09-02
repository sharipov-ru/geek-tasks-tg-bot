require './lib/success_result'
require './lib/failure_result'

module Commands
  class BaseCommand
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
