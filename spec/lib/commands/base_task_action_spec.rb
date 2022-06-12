require './lib/commands/base_task_action'
require './lib/input'
require './lib/user'

describe Commands::BaseTaskAction do
  let(:command) { described_class.new(input) }
  let(:input) { double(Input, text: '/mvt hd', user: user) }
  let(:user) { double(User, id: 'user-id') }

  describe '#action_name' do
    subject { command.action_name }

    it { is_expected.to eq('/mvt') }
  end

  describe '#current_task_token' do
    subject { command.current_task_token }

    it { is_expected.to eq('hd') }
  end
end
