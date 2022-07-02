require './lib/commands/base_command'

describe Commands::BaseCommand do
  let(:command) { described_class.new(input) }
  let(:input) { double }

  describe '#execute' do
    subject { command.execute }

    before do
      expect(command).to receive(:run_command).and_return(run_command_result)
    end

    context 'when command succeeds' do
      let(:run_command_result) { true }

      it 'returns success callback' do
        expect(command).to receive(:success)
        expect(command).not_to receive(:failure)

        subject
      end
    end

    context 'when command fails' do
      let(:run_command_result) { false }

      it 'returns failure callback' do
        expect(command).not_to receive(:success)
        expect(command).to receive(:failure)

        subject
      end
    end
  end
end
