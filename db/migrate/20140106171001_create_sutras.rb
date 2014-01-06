class CreateSutras < ActiveRecord::Migration
  def change
    create_table :sutras do |t|
      t.string :verse
      t.text :devanagari
      t.text :transliteration
      t.text :english
      t.text :link

      t.timestamps
    end
  end
end
