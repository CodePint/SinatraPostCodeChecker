require_relative '../services/postcodes_checker/exceptions'

class Postcode < ActiveRecord::Base
  include PostcodesCheckerExceptions
  @pattern = /^([A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}|GIR ?0A{2})$/mi

  def self.allowed?(postcode)
    self.where(value: sanitize(postcode), allowed: true).first.present?
  end

  def self.allowed_list
    self.where(allowed: true)
  end

  def self.sanitize(postcode)
    postcode.delete(" \t\r\n")
  end

  def self.validate!(postcode)
    @pattern.match?(sanitize(postcode)) || (raise PostcodeInvalid)
  end

end
