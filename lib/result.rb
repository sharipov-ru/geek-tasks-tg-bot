class Result
  attr_reader :text

  def initialize(text:)
    @text = text
  end

  def success?
    raise NotImplementedError
  end

  def failure?
    !success?
  end
end
