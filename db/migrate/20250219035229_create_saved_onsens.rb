class CreateSavedOnsens < ActiveRecord::Migration[7.1]
  def change
    create_table :onsens do |t|
      t.string :name
      t.string :location
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
