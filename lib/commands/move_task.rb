require './lib/commands/base_task_action'

module Commands
  class MoveTask < BaseTaskAction
    attr_reader :new_scope

    def initialize(input, new_scope:)
      @new_scope = new_scope

      super(input)
    end

    def run_command
      return false unless current_task

      current_task.scope = new_scope
      task_repo.update(current_task)
    end

    private

    def current_task
      @current_task ||= task_repo.all_tasks.find { |t| t.token == current_task_token }
    end

    def task_repo
      @task_repo ||= Repositories::TaskRepository.new(user: input.user)
    end

    def success
      Result.new(text: "Task has been moved to #{new_scope}")
    end

    def failure
      Result.new(text: "Error while updating a task to #{new_scope}")
    end
  end
end
