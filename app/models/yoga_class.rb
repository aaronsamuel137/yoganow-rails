class YogaClass < ActiveRecord::Base
  validates_uniqueness_of :name, scope: [:start, :end, :day, :studio]
  def self.delete_old()
    self.where("created_at <= ?", Time.now - 1.day).destroy_all
  end

  def self.load_classes()
    ApiHelper.load_classes()
  end
end
