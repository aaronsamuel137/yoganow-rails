class ChangeDateFormatInMyTable < ActiveRecord::Migration
  def change
    remove_column :yoga_classes, :start
    remove_column :yoga_classes, :end
    add_column :yoga_classes, :start, :datetime
    add_column :yoga_classes, :end, :datetime
  end
end
