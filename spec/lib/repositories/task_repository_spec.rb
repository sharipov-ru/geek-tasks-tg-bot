require 'json'
require './lib/repositories/task_repository'

describe Repositories::TaskRepository do
  let(:repository) { described_class.new(user: user, mapper: mapper, datastore: datastore) }
  let(:user) { double(id: 'test-user-id') }
  let(:mapper) { double }
  let(:datastore) { double }

  describe '#inbox_tasks' do
    subject { repository.inbox_tasks }

    specify do
      expect(repository).to receive(:tasks_by_scope).with(scope: 'inbox')

      subject
    end
  end

  describe '#today_tasks' do
    subject { repository.today_tasks }

    specify do
      expect(repository).to receive(:tasks_by_scope).with(scope: 'today')

      subject
    end
  end

  describe '#week_tasks' do
    subject { repository.week_tasks }

    specify do
      expect(repository).to receive(:tasks_by_scope).with(scope: 'week')

      subject
    end
  end

  describe '#later_tasks' do
    subject { repository.later_tasks }

    specify do
      expect(repository).to receive(:tasks_by_scope).with(scope: 'later')

      subject
    end
  end

  describe '#tasks_by_scope' do
    subject { repository.tasks_by_scope(scope: scope) }

    let(:scope) { 'test-scope' }

    before do
      expect(datastore)
        .to receive(:get)
        .with('test-user-id-tasks')
        .and_return(datastore_result)
    end

    context 'when datastore_result is nil' do
      let(:datastore_result) { nil }

      before { expect(mapper).not_to receive(:build_tasks) }

      it { is_expected.to eq([]) }
    end

    context 'when datastore_result is a blank string' do
      let(:datastore_result) { '' }

      before { expect(mapper).not_to receive(:build_tasks) }

      it { is_expected.to eq([]) }
    end

    context 'when datastore_result is an empty array' do
      let(:datastore_result) { [] }

      before { expect(mapper).not_to receive(:build_tasks) }

      it { is_expected.to eq([]) }
    end

    context 'when datastore_result has no matching tasks to scope' do
      let(:datastore_result) do
        [
          { token: 'bb', text: 'Hidden', scope: 'unknown' }
        ].to_json
      end

      before { expect(mapper).not_to receive(:build_tasks) }

      it { is_expected.to eq([]) }
    end

    context 'when datastore_result has matching tasks to scope' do
      let(:datastore_result) do
        [
          { token: 'bb', text: 'Hidden', scope: scope }
        ].to_json
      end
      let(:task) { double }

      before do
        expect(mapper)
          .to receive(:build_tasks)
          .with([{ 'token' => 'bb', 'text' => 'Hidden', 'scope' => scope }])
          .and_return([task])
      end

      it { is_expected.to eq([task]) }
    end
  end

  describe '#add_inbox_task' do
    subject { repository.add_inbox_task(task) }

    let(:task) { Entities::Task.new(token: 'gh', text: 'New task', scope: 'inbox') }

    before do
      expect(datastore)
        .to receive(:get)
        .with('test-user-id-tasks')
        .and_return(datastore_result)
    end

    context 'when there was no tasks yet' do
      let(:datastore_result) { [] }

      context 'successful push to datastore' do
        let(:datastore_push_result) { 'OK' }

        it 'pushes task to datastore' do
          expect(datastore)
            .to receive(:set)
            .with('test-user-id-tasks', anything)
            .and_return(datastore_push_result)

          expect(subject).to be true
        end
      end

      context 'failing push to datastore' do
        let(:datastore_push_result) { 'NOT_OK' }

        it 'pushes task to datastore' do
          expect(datastore)
            .to receive(:set)
            .with('test-user-id-tasks', anything)
            .and_return(datastore_push_result)

          expect(subject).to be false
        end
      end
    end
  end

  describe '#update' do
    subject { repository.update(task) }

    before do
      expect(datastore)
        .to receive(:get)
        .with('test-user-id-tasks')
        .and_return(datastore_result)
    end

    context 'when task exists in datastore' do
      let(:task) { Entities::Task.new(token: 'aa', text: 'New text', scope: 'week') }

      let(:datastore_result) do
        [
          { token: 'bb', text: 'Text', scope: 'inbox' },
          { token: 'aa', text: 'Old text', scope: 'inbox' }
        ].to_json
      end
      let(:datastore_push_result) { 'OK' }

      it 'updates task' do
        expect(datastore)
          .to receive(:set)
          .with(
            'test-user-id-tasks',
            '[{"token":"bb","text":"Text","scope":"inbox"},'\
            '{"token":"aa","text":"New text","scope":"week"}]'
          )
          .and_return(datastore_push_result)

        subject
      end
    end
  end

  describe '#remove' do
    subject { repository.remove(task) }

    before do
      expect(datastore)
        .to receive(:get)
        .with('test-user-id-tasks')
        .and_return(datastore_result)
    end

    context 'when task exists in datastore' do
      let(:task) { Entities::Task.new(token: 'aa', text: 'text', scope: 'inbox') }

      let(:datastore_result) do
        [
          { token: 'bb', text: 'Text', scope: 'inbox' },
          { token: 'aa', text: 'Old text', scope: 'inbox' }
        ].to_json
      end
      let(:datastore_push_result) { 'OK' }

      it 'removes task' do
        expect(datastore)
          .to receive(:set)
          .with(
            'test-user-id-tasks',
            '[{"token":"bb","text":"Text","scope":"inbox"}]'
          )
          .and_return(datastore_push_result)

        subject
      end
    end
  end

  describe '#bulk_remove' do
    subject { repository.bulk_remove(tasks) }

    before do
      expect(datastore)
        .to receive(:get)
        .with('test-user-id-tasks')
        .and_return(datastore_result)
    end

    context 'when selected single task exists in datastore' do
      let(:tasks) do
        [
          Entities::Task.new(token: 'aa', text: 'text', scope: 'inbox')
        ]
      end

      let(:datastore_result) do
        [
          { token: 'bb', text: 'Text', scope: 'inbox' },
          { token: 'aa', text: 'Old text', scope: 'inbox' }
        ].to_json
      end

      let(:datastore_push_result) { 'OK' }

      it 'removes task' do
        expect(datastore)
          .to receive(:set)
          .with(
            'test-user-id-tasks',
            '[{"token":"bb","text":"Text","scope":"inbox"}]'
          )
          .and_return(datastore_push_result)

        subject
      end
    end

    context 'when multiple single task exists in datastore' do
      let(:tasks) do
        [
          Entities::Task.new(token: 'aa', text: 'text', scope: 'inbox'),
          Entities::Task.new(token: 'bb', text: 'text', scope: 'inbox')
        ]
      end

      let(:datastore_result) do
        [
          { token: 'bb', text: 'Text', scope: 'inbox' },
          { token: 'cc', text: 'Text', scope: 'inbox' },
          { token: 'aa', text: 'Old text', scope: 'inbox' }
        ].to_json
      end

      let(:datastore_push_result) { 'OK' }

      it 'removes task' do
        expect(datastore)
          .to receive(:set)
          .with(
            'test-user-id-tasks',
            '[{"token":"cc","text":"Text","scope":"inbox"}]'
          )
          .and_return(datastore_push_result)

        subject
      end
    end
  end
end
