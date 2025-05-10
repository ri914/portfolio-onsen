class CreateImageDescriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :image_descriptions do |t|
      t.references :onsen, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
