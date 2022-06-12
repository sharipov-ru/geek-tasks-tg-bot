require './lib/entities/task'

describe Entities::Task do
  let(:entity) { described_class.new(text: 'Test', scope: 'today', token: 'ty') }

  describe '#text' do
    subject { entity.text }

    it { is_expected.to eq('Test') }
  end

  describe '#scope' do
    subject { entity.scope }

    it { is_expected.to eq('today') }
  end

  describe '#token' do
    subject { entity.token }

    it { is_expected.to eq('ty') }
  end
end
