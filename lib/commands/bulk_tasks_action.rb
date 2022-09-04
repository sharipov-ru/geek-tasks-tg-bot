require './lib/commands/base_input_command'

module Commands
  # Base class to handle cli commands with task as an argument
  # Parses input text and provides *action_name* and *current_task_tokens*
  #
  # Example:
  #   * /rm id
  #   * /mvt id
  #   * /mvt ab ce df
  class BulkTasksAction < BaseInputCommand
    def action_name
      @action_name ||= input_text_parts.first
    end

    def current_task_tokens
      @current_task_tokens ||= input_text_parts[1..]
    end

    private

    def input_text_parts
      @input_text_parts ||= input.text.split(' ')
    end

    def current_tasks
      @current_tasks ||= task_repo.all_tasks.select { |t| current_task_tokens.include?(t.token) }
    end

    def task_repo
      @task_repo ||= Repositories::TaskRepository.new(user: input.user)
    end
  end
end
