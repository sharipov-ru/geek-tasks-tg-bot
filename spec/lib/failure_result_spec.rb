require './lib/failure_result'

describe FailureResult do
  let(:result) { FailureResult.new(text: text) }
  let(:text) { 'abc123' }

  describe '#text' do
    subject { result.text }

    it { is_expected.to eq('abc123') }
  end

  describe '#success?' do
    subject { result.success? }

    it { is_expected.to be false }
  end

  describe '#failure?' do
    subject { result.failure? }

    it { is_expected.to be true }
  end
end
