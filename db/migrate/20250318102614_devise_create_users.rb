class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:users)
      create_table :users do |t|
        t.string :email,              null: false, default: ""
        t.string :encrypted_password, null: false, default: ""

        t.string   :reset_password_token
        t.datetime :reset_password_sent_at

        t.datetime :remember_created_at

        t.timestamps null: false
      end
    end

    add_column :users, :name, :string unless column_exists?(:users, :name)

    add_index :users, :email, unique: true unless index_exists?(:users, :email)
    add_index :users, :reset_password_token, unique: true unless index_exists?(:users, :reset_password_token)
  end
end
