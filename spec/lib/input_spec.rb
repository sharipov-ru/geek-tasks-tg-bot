require './lib/input'

describe Input do
  let(:input) { Input.new(message) }

  describe '#text' do
    subject { input.text }

    let(:message) { double(text: 'abc123') }

    it { is_expected.to eq('abc123') }
  end

  describe '#valid?' do
    subject { input.valid? }

    context 'when text is missing' do
      let(:message) { double(text: ' ') }

      it { is_expected.to be false }
    end

    context 'when text present' do
      let(:message) { double(text: 'test') }

      it { is_expected.to be true }
    end
  end
end
