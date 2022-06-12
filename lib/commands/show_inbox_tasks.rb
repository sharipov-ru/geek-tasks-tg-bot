require './lib/commands/show_tasks'

module Commands
  class ShowInboxTasks < ShowTasks
    def fetch_tasks
      task_repo.inbox_tasks
    end
  end
end
