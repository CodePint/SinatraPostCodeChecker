require 'faraday'

module PostcodesApiExceptions
  class PostcodesApiClientError < StandardError
    def initialize(msg="")
      super(msg)
    end
  end

  class InternalServerError < PostcodesApiClientError
    def initialize(msg="")
      super(msg)
    end
  end

  class BadRequestError < PostcodesApiClientError
    def initialize(msg="")
      super(msg)
    end
  end

  class NotFoundError < PostcodesApiClientError
    def initialize(msg="")
      super(msg)
    end
  end

  HTTP_EXCEPTIONS = Hash.new(PostcodesApiClientError)
  HTTP_EXCEPTIONS.update(
    400 => BadRequestError,
    404 => NotFoundError,
    500 => InternalServerError
  )

  FARADAY_EXCEPTIONS = [
    Faraday::ConnectionFailed,
    Faraday::RetriableResponse,
    Faraday::TimeoutError,
    Errno::ETIMEDOUT,
  ]
end