module PostcodesCheckerExceptions
  class PostcodesServiceCheckerError < StandardError
    def initialize(msg="")
      super(msg)
    end
  end

  class PostcodeNotFound < PostcodesServiceCheckerError
    def initialize(msg="Postcode not found")
      super(msg)
    end
  end

  class PostcodeInvalid < PostcodesServiceCheckerError
    def initialize(msg="Invalid postcode")
      super(msg)
    end
  end

  POSTCODES_HTTP_EXCEPTIONS = {
    PostcodeInvalid  => 400,
    PostcodeNotFound => 404
  }.freeze
end
