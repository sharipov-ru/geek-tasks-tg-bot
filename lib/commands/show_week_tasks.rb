require './lib/commands/show_tasks'

module Commands
  class ShowWeekTasks < ShowTasks
    def fetch_tasks
      task_repo.week_tasks
    end
  end
end
