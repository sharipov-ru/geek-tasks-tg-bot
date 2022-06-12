require './lib/commands/show_tasks'
require './lib/input'
require './lib/user'
require './lib/result'
require './lib/repositories/task_repository'

describe Commands::ShowTasks do
  let(:command) { described_class.new(input) }
  let(:input) { double(Input, text: 'test', user: user) }
  let(:user) { double(User, id: 'user-id') }

  describe '#execute' do
    subject { command.execute }

    context 'when success' do
      context 'tasks is empty' do
        before do
          expect(command).to receive(:fetch_tasks).and_return([])
        end

        it 'returns success Result with empty tasks' do
          aggregate_failures do
            expect(subject).to be_kind_of(Result)
            expect(subject.text).to eq(described_class::NO_TASKS_MESSAGE)
          end
        end
      end

      context 'tasks present' do
        before do
          expect(command).to receive(:fetch_tasks).and_return(tasks)
        end

        let(:tasks) do
          [
            Entities::Task.new(text: 'First', scope: 'inbox', token: 'aa'),
            Entities::Task.new(text: 'Second', scope: 'inbox', token: 'bb'),
            Entities::Task.new(text: 'Third', scope: 'inbox', token: 'cc')
          ]
        end

        it 'returns success Result with empty tasks' do
          aggregate_failures do
            expect(subject).to be_kind_of(Result)
            expect(subject.text).to eq("aa. First\nbb. Second\ncc. Third")
          end
        end
      end
    end

    context 'when failure' do
      before do
        expect(command).to receive(:fetch_tasks).and_return(false)
      end

      it 'returns failure Result' do
        aggregate_failures do
          expect(subject).to be_kind_of(Result)
          expect(subject.text).to eq(described_class::FAILURE_MESSAGE)
        end
      end
    end
  end
end
