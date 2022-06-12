require './lib/commands/helpers/uniq_token'

describe Commands::Helpers::UniqToken do
  describe '.generate' do
    subject { described_class.generate(existing_tokens) }

    context 'existing_tokens is empty' do
      let(:existing_tokens) { [] }

      it 'generates 2 symbol token' do
        token = subject

        expect(token).to be_kind_of(String)
        expect(token.length).to eq(2)
      end
    end

    context 'existing_tokens take all possible variants except 1' do
      let(:existing_tokens) do
        all_possible_tokens.reject { |e| e == 'nt' }
      end

      let(:all_possible_tokens) do
        symbols = ('a'..'z').to_a
        symbols.map { |first| symbols.map { |second| first + second } }.flatten
      end

      it 'finds the only remaining token' do
        token = subject

        expect(token).to be_kind_of(String)
        expect(token.length).to eq(2)
        expect(token).to eq('nt')
      end
    end
  end
end
