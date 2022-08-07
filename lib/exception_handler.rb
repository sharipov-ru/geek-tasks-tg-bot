module ExceptionHandler
  def exception_handler
    yield
  rescue Telegram::Bot::Exceptions::Base

  end
end
