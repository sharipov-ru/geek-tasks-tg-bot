require './lib/commands/bulk_tasks_action'

module Commands
  class RemoveTask < BulkTasksAction
    def run_command
      return false unless current_tasks.any?

      task_repo.bulk_remove(current_tasks)
    end

    private

    def success
      SuccessResult.new(text: "Tasks #{current_task_tokens} has been removed")
    end

    def failure
      FailureResult.new(text: "Error while removing tasks #{current_task_tokens}")
    end
  end
end
