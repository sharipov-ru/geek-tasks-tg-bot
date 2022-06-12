require './lib/commands/show_today_tasks'
require './lib/input'
require './lib/user'
require './lib/repositories/task_repository'

describe Commands::ShowTodayTasks do
  let(:command) { described_class.new(input) }
  let(:input) { double(Input, text: 'test', user: user) }
  let(:user) { double(User, id: 'user-id') }

  describe '#fetch_tasks' do
    subject { command.fetch_tasks }

    let(:task_repo_klass) { Repositories::TaskRepository }
    let(:task_repo_mock) { double(task_repo_klass) }

    before do
      expect(task_repo_klass)
        .to receive(:new)
        .with(user: user)
        .and_return(task_repo_mock)
    end

    it 'calls today_tasks from task_repo' do
      expect(task_repo_mock).to receive(:today_tasks)

      subject
    end
  end
end
