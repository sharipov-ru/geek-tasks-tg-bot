require './lib/commands/stop'
require './lib/input'
require './lib/user'
require './lib/success_result'

describe Commands::Stop do
  let(:command) { described_class.new(input) }
  let(:input) { double(Input, text: '/stop', user: user) }
  let(:user) { double(User, id: 'user-id') }

  describe '#execute' do
    subject { command.execute }

    it 'returns success message' do
      aggregate_failures do
        expect(subject).to be_kind_of(SuccessResult)
        expect(subject.text).to eq(described_class::MESSAGE)
      end
    end
  end
end
