require './lib/commands/move_task'
require './lib/input'
require './lib/user'
require './lib/result'
require './lib/repositories/task_repository'

describe Commands::MoveTask do
  let(:command) { described_class.new(input, new_scope: new_scope) }
  let(:new_scope) { 'week' }
  let(:input) { double(Input, text: '/mvt hd', user: user) }
  let(:user) { double(User, id: 'user-id') }

  describe '#execute' do
    subject { command.execute }

    before do
      expect(command).to receive(:run_command).and_return(run_command_result)
    end

    context 'when success' do
      let(:run_command_result) { true }

      it 'returns success Result' do
        aggregate_failures do
          expect(subject).to be_kind_of(Result)
          expect(subject.text).to eq('Task has been moved to week')
        end
      end
    end

    context 'when failure' do
      let(:run_command_result) { false }

      it 'returns failure Result' do
        aggregate_failures do
          expect(subject).to be_kind_of(Result)
          expect(subject.text).to eq('Error while updating a task to week')
        end
      end
    end
  end

  describe '#run_command' do
    subject { command.run_command }

    let(:task_repo) { double(Repositories::TaskRepository) }

    before do
      expect(Repositories::TaskRepository)
        .to receive(:new)
        .with(user: user)
        .and_return(task_repo)
      expect(task_repo)
        .to receive(:all_tasks)
        .and_return(all_tasks)
    end

    context 'when all_tasks is empty' do
      let(:all_tasks) { [] }

      it { is_expected.to be false }
    end

    context 'when all_tasks has not match with currnet task' do
      let(:all_tasks) do
        [
          Entities::Task.new(text: 'First', scope: 'inbox', token: 'aa'),
          Entities::Task.new(text: 'Second', scope: 'inbox', token: 'bb'),
          Entities::Task.new(text: 'Third', scope: 'inbox', token: 'cc')
        ]
      end

      it { is_expected.to be false }
    end

    context 'when all_tasks has a match with currnet task' do
      let(:all_tasks) do
        [
          Entities::Task.new(text: 'First', scope: 'inbox', token: 'aa'),
          Entities::Task.new(text: 'Second', scope: 'inbox', token: 'hd'),
          Entities::Task.new(text: 'Third', scope: 'inbox', token: 'cc')
        ]
      end

      it 'pushes an updated task to repository' do
        expect(task_repo)
          .to receive(:update)
          .with(having_attributes(scope: new_scope, token: 'hd', text: 'Second'))
          .and_return(true)

        subject
      end
    end
  end
end
