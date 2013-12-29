class CreateYogaClasses < ActiveRecord::Migration
  def change
    create_table :yoga_classes do |t|
      t.string :name
      t.string :start
      t.string :end
      t.date :day

      t.timestamps
    end
  end
end
