module Entities
  class Task
    attr_reader :text, :token
    attr_accessor :scope

    def initialize(text:, scope:, token:)
      @text = text
      @scope = scope
      @token = token
    end
  end
end
