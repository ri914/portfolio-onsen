class CreateSavedOnsens < ActiveRecord::Migration[7.1]
  def change
    create_table :saved_onsens do |t|
      t.references :user, null: false, foreign_key: true
      t.references :onsen, null: false, foreign_key: true

      t.timestamps
    end
  end
end
