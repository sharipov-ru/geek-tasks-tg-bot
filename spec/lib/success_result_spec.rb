require './lib/success_result'

describe SuccessResult do
  let(:result) { SuccessResult.new(text: text) }
  let(:text) { 'abc123' }

  describe '#text' do
    subject { result.text }

    it { is_expected.to eq('abc123') }
  end

  describe '#success?' do
    subject { result.success? }

    it { is_expected.to be true }
  end

  describe '#failure?' do
    subject { result.failure? }

    it { is_expected.to be false }
  end
end
