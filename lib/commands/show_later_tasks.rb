require './lib/commands/base_command'

module Commands
  class ShowLaterTasks < ShowTasks
    def fetch_tasks
      task_repo.later_tasks
    end
  end
end
