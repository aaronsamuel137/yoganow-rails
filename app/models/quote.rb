class Quote < ActiveRecord::Base
  validates_uniqueness_of :content
end
