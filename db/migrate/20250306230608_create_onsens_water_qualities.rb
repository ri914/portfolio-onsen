class CreateOnsensWaterQualities < ActiveRecord::Migration[7.1]
  def change
    create_table :onsens_water_qualities do |t|
      t.references :onsen, null: false, foreign_key: true
      t.references :water_quality, null: false, foreign_key: true

      t.timestamps
    end

    add_index :onsens_water_qualities, [:onsen_id, :water_quality_id], unique: true
  end
end
