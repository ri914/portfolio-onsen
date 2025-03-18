class CreateWaterQualities < ActiveRecord::Migration[7.1]
  def change
    create_table :water_qualities do |t|
      t.string :name
      t.timestamps
    end
  end
end
