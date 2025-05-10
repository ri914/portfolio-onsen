class CreateOnsensWithUserInfo < ActiveRecord::Migration[7.1]
  def change
    create_table :onsens do |t|
      t.string :name, null: false
      t.string :location
      t.text :description
      t.string :image
      t.text :activities
      t.string :best_time_to_visit
      t.text :access_info
      t.decimal :rating, precision: 2, scale: 1
      t.integer :user_id, null: false
      t.integer :saved_by_user_id

      t.timestamps
    end

    add_index :onsens, :user_id
    add_index :onsens, :saved_by_user_id

    reversible do |dir|
      dir.up do
        execute "UPDATE onsens SET user_id = 1"
      end
    end

    add_foreign_key :onsens, :users
  end
end
