require './lib/commands/bulk_tasks_action'

module Commands
  class RemoveTask < BulkTasksAction
    def run_command
      return false unless current_tasks.any?

      task_repo.bulk_remove(current_tasks)
    end

    private

    def success
      text = "#{subject.capitalize} #{current_task_tokens_as_string} #{has} been removed"
      SuccessResult.new(text: text)
    end

    def failure
      text = "Error while removing #{subject} #{current_task_tokens_as_string}"
      FailureResult.new(text: text)
    end

    def subject
      current_task_tokens.size > 1 ? 'tasks' : 'task'
    end

    def has
      current_task_tokens.size > 1 ? 'have' : 'has'
    end
  end
end
