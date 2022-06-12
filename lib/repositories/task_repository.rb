require 'redis'
require 'json'
require './lib/repositories/mappers/task_mapper'

module Repositories
  # Persistence layer for tasks
  #
  # Encapsulates interaction with the database, accepts and returns Entities::Task objects
  class TaskRepository
    REDIS_URL = ENV['CMD_TASKS_REDIS_URL']

    def initialize(user:, mapper: Mappers::TaskMapper.new, datastore: Redis.new(url: REDIS_URL))
      @user = user
      @datastore = datastore
      @mapper = mapper
    end

    def inbox_tasks
      tasks_by_scope(scope: 'inbox')
    end

    def today_tasks
      tasks_by_scope(scope: 'today')
    end

    def week_tasks
      tasks_by_scope(scope: 'week')
    end

    def later_tasks
      tasks_by_scope(scope: 'later')
    end

    def all_tasks
      dataset = all_task_records
      dataset.any? ? mapper.build_tasks(dataset) : []
    end

    def tasks_by_scope(scope:)
      dataset = fetch_task_records(scope: scope)
      dataset.any? ? mapper.build_tasks(dataset) : []
    end

    def add_inbox_task(task)
      updated_tasks = all_task_records << { token: task.token, text: task.text, scope: task.scope }

      result = datastore.set("#{user.id}-tasks", updated_tasks.to_json)
      result == 'OK'
    end

    def update(task)
      updated_tasks = all_task_records.map do |task_record|
        if task_record['token'] == task.token
          task_record['text'] = task.text
          task_record['scope'] = task.scope
        end

        task_record
      end

      result = datastore.set("#{user.id}-tasks", updated_tasks.to_json)
      result == 'OK'
    end

    def remove(task)
      updated_tasks = all_task_records.reject { |task_record| task_record['token'] == task.token }

      result = datastore.set("#{user.id}-tasks", updated_tasks.to_json)
      result == 'OK'
    end

    private

    attr_reader :user, :datastore, :mapper

    def fetch_task_records(scope:)
      all_task_records.select { |t| t['scope'] == scope }
    end

    def all_task_records
      json = datastore.get("#{user.id}-tasks")

      return [] unless json
      return [] if json.empty?

      JSON.parse(json)
    end
  end
end
