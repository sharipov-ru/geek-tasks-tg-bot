require './lib/result'

class SuccessResult < Result
  def success?
    true
  end
end
