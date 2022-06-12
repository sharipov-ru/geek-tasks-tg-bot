require './lib/commands/base_command'

module Commands
  # Base class to handle cli commands with task as an argument
  # Parses input text and provides *action_name* and *current_task_token*
  #
  # Example:
  #   * /rm id
  #   * /mvt id
  class BaseTaskAction < BaseCommand
    def action_name
      @action_name ||= input_text_parts.first
    end

    def current_task_token
      @current_task_token ||= input_text_parts.last
    end

    private

    def input_text_parts
      @input_text_parts ||= input.text.split(' ')
    end

    def current_task
      @current_task ||= task_repo.all_tasks.find { |t| t.token == current_task_token }
    end

    def task_repo
      @task_repo ||= Repositories::TaskRepository.new(user: input.user)
    end
  end
end
