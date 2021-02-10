class LSOA < ActiveRecord::Base
  self.table_name = "LSOAs"

  def self.allowed_list
    self.where(allowed: true)
  end

  def self.allowed?(lsoa)
    # can be replaced with postgres and db query if allowed list grows
    lsoa && self.allowed_list.any? {|l| lsoa.include?(l.value.upcase) }
  end

end
