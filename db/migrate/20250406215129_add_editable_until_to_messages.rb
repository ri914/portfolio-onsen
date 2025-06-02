class AddEditableUntilToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :editable_until, :datetime
  end
end
