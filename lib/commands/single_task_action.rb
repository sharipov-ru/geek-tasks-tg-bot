module Commands
  class SingleTaskAction < BaseCommand
    def task_token
      input.text
    end
  end
end
