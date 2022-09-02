require './lib/result'

describe Result do
  let(:result) { Result.new(text: text) }
  let(:text) { 'abc123' }

  describe '#text' do
    subject { result.text }

    it { is_expected.to eq('abc123') }
  end

  describe '#success?' do
    subject { result.success? }

    specify do
      expect { subject }.to raise_error(NotImplementedError)
    end
  end

  describe '#failure?' do
    subject { result.failure? }

    specify do
      expect { subject }.to raise_error(NotImplementedError)
    end
  end
end
