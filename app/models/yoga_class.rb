class YogaClass < ActiveRecord::Base
  def self.delete_old()
    self.where("created_at <= ?", Time.now - 1.weeks).destroy_all
  end
end
