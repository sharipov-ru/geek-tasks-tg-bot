require './lib/commands/base_task_action'

module Commands
  class RemoveTask < BaseTaskAction
    def run_command
      return false unless current_task

      task_repo.remove(current_task)
    end

    private

    def success
      SuccessResult.new(text: "Task #{current_task_token} has been removed")
    end

    def failure
      FailureResult.new(text: "Error while removing task #{current_task_token}")
    end
  end
end
