require './lib/result'

class FailureResult < Result
  def success?
    false
  end
end
