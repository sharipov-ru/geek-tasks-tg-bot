require './lib/commands/add_inbox_task'
require './lib/input'
require './lib/user'
require './lib/result'
require './lib/repositories/task_repository'
require './lib/commands/helpers/uniq_token'

describe Commands::AddInboxTask do
  let(:command) { described_class.new(input) }
  let(:input) { double(Input, text: 'test', user: user) }
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
          expect(subject.text).to eq(described_class::SUCCESS_MESSAGE)
        end
      end
    end

    context 'when failure' do
      let(:run_command_result) { false }

      it 'returns failure Result' do
        aggregate_failures do
          expect(subject).to be_kind_of(Result)
          expect(subject.text).to eq(described_class::FAILURE_MESSAGE)
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
      expect(Commands::Helpers::UniqToken)
        .to receive(:generate)
        .with(all_tasks.map(&:token))
        .and_return('xs')
    end

    context 'when all_tasks is empty' do
      let(:all_tasks) { [] }

      it 'pushes a new task to repository' do
        expect(task_repo)
          .to receive(:add_inbox_task)
          .with(having_attributes(scope: 'inbox', token: 'xs', text: 'test'))
          .and_return(true)

        subject
      end
    end
  end
end
