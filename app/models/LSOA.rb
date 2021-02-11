class LSOA < ActiveRecord::Base
  self.table_name = "LSOAs"

  def self.allowed_list
    where(allowed: true)
  end

  def self.allowed?(lsoa)
    # can be replaced with postgres and db query if allowed list grows
    lsoa && allowed_list.any? {|l| lsoa.include?(l.value.upcase) }
  end
end
