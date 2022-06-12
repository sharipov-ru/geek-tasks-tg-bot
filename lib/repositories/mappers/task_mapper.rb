require './lib/entities/task'

module Repositories
  module Mappers
    class TaskMapper
      def build_tasks(tasks_dataset)
        tasks_dataset.map { |hash| build_task(hash) }
      end

      private

      def build_task(hash)
        Entities::Task.new(
          token: hash['token'],
          text: hash['text'],
          scope: hash['scope']
        )
      end
    end
  end
end
