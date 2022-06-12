require './lib/commands/show_tasks'

module Commands
  class ShowTodayTasks < ShowTasks
    def fetch_tasks
      task_repo.today_tasks
    end
  end
end
