require './lib/commands/base_command'
require './lib/repositories/task_repository'

module Commands
  class ShowTasks < BaseCommand
    NO_TASKS_MESSAGE = 'No tasks exist'.freeze
    FAILURE_MESSAGE = 'Error while loading tasks'.freeze

    def run_command
      @tasks = fetch_tasks
    end

    def fetch_tasks
      raise NotImplementedError
    end

    private

    def task_repo
      Repositories::TaskRepository.new(user: input.user)
    end

    def success
      text =
        if @tasks.any?
          @tasks.map { |task| "#{task.token}. #{task.text}" }.join("\n")
        else
          NO_TASKS_MESSAGE
        end

      SuccessResult.new(text: text)
    end

    def failure
      FailureResult.new(text: FAILURE_MESSAGE)
    end
  end
end
