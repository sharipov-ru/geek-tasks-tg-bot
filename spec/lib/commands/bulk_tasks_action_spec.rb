require './lib/commands/bulk_tasks_action'
require './lib/input'
require './lib/user'

describe Commands::BulkTasksAction do
  let(:command) { described_class.new(input) }
  let(:input) { double(Input, text: text, user: user) }
  let(:user) { double(User, id: 'user-id') }

  describe '#action_name' do
    subject { command.action_name }

    let(:text) { '/mvt hd' }

    it { is_expected.to eq('/mvt') }
  end

  describe '#current_task_tokens' do
    subject { command.current_task_tokens }

    context 'single token' do
      let(:text) { '/mvt hd' }

      it { is_expected.to eq(%w[hd]) }
    end

    context 'multiple tokens' do
      let(:text) { '/mvt hd ab dc fg' }

      it { is_expected.to eq(%w[hd ab dc fg]) }
    end
  end

  describe '#current_task_tokens_as_string' do
    subject { command.current_task_tokens_as_string }

    let(:text) { '/mvt hd ab dc fg' }

    it { is_expected.to eq('hd ab dc fg') }
  end
end
