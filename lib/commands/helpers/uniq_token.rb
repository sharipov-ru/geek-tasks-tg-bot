module Commands
  module Helpers
    class UniqToken
      def self.generate(current_tokens)
        begin
          id = ('a'..'z').to_a.sample(2).join
        end while current_tokens.include?(id)
        id
      end
    end
  end
end
