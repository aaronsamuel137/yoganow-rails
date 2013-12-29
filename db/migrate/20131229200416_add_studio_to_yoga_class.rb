class AddStudioToYogaClass < ActiveRecord::Migration
  def change
    add_column :yoga_classes, :studio, :string
  end
end
