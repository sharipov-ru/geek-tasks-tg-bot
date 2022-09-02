require './lib/commands/base_input_command'
require './lib/repositories/task_repository'
require './lib/entities/task'
require './lib/commands/helpers/uniq_token'

module Commands
  class AddInboxTask < BaseInputCommand
    SUCCESS_MESSAGE = 'Task has been added'.freeze
    FAILURE_MESSAGE = 'Error while adding a task'.freeze

    def run_command
      task_repo = Repositories::TaskRepository.new(user: input.user)
      all_tasks = task_repo.all_tasks

      new_task = Entities::Task.new(
        text: input.text,
        scope: 'inbox',
        token: Helpers::UniqToken.generate(all_tasks.map(&:token))
      )

      task_repo.add_inbox_task(new_task)
    end

    private

    def success
      SuccessResult.new(text: SUCCESS_MESSAGE)
    end

    def failure
      FailureResult.new(text: FAILURE_MESSAGE)
    end
  end
end
