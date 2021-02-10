module PostcodesCheckerExceptions
  class PostcodeNotFound < StandardError
    def initialize(msg="")
      super(msg)
    end
  end

  class PostcodeInvalid < StandardError
    def initialize(msg="Invalid postcode")
      super(msg)
    end
  end
end