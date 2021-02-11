module PostcodesCheckerExceptions
  class PostcodeNotFound < StandardError
    def initialize(msg="Postcode not found")
      super(msg)
    end
  end

  class PostcodeInvalid < StandardError
    def initialize(msg="Invalid postcode")
      super(msg)
    end
  end
end
