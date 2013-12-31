class YogaClass < ActiveRecord::Base
  def self.delete_old()
    self.where("created_at <= ?", Time.now - 1.day).destroy_all
  end

  def self.load_classes()
    studios = ['yogapod', 'corepower_north', 'corepower_south', 'corepower_hill']
    num_classes = -1
    start_time = -1
    studios.each do |studio|
      ApiHelper.get_studio_data(studio, num_classes, start_time)
    end
  end
end
