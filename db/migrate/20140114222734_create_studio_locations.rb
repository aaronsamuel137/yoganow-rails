class CreateStudioLocations < ActiveRecord::Migration
  def change
    create_table :studio_locations do |t|
      t.string :name
      t.string :lat
      t.string :lng

      t.timestamps
    end
  end
end
