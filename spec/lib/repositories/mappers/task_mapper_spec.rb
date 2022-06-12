require './lib/repositories/mappers/task_mapper'

describe Repositories::Mappers::TaskMapper do
  let(:mapper) { described_class.new }

  describe '#build_tasks' do
    subject { mapper.build_tasks(tasks_dataset) }

    context 'when dataset is empty' do
      let(:tasks_dataset) { [] }

      it { is_expected.to eq([]) }
    end

    context 'when dataset has 1 task' do
      let(:tasks_dataset) do
        [
          { 'token' => 'ab', 'text' => 'Test task', 'scope' => 'today' }
        ]
      end

      it 'builds task entity object with proper attributes' do
        entity = subject.first

        aggregate_failures do
          expect(entity).to be_kind_of(Entities::Task)
          expect(entity.token).to eq('ab')
          expect(entity.text).to eq('Test task')
          expect(entity.scope).to eq('today')
        end
      end
    end

    context 'when dataset has multiple tasks' do
      let(:tasks_dataset) do
        [
          { 'token' => 'ab', 'text' => 'Test task', 'scope' => 'today' },
          { 'token' => 'xs', 'text' => 'Second task', 'scope' => 'later' }
        ]
      end

      it 'returns multiple task entities' do
        entities = subject

        aggregate_failures do
          expect(entities.size).to eq(2)
          expect(entities.map(&:token)).to eq(%w[ab xs])
          expect(entities.map(&:text)).to eq(['Test task', 'Second task'])
          expect(entities.map(&:scope)).to eq(%w[today later])
        end
      end
    end
  end
end
