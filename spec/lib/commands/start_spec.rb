require './lib/commands/start'
require './lib/input'
require './lib/user'
require './lib/success_result'

describe Commands::Start do
  let(:command) { described_class.new(input) }
  let(:input) { double(Input, text: '/start', user: user) }
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
