class AddDescriptionToYogaClass < ActiveRecord::Migration
  def change
    add_column :yoga_classes, :description, :text
  end
end
