class Sutra < ActiveRecord::Base
  validates_uniqueness_of :verse
end
