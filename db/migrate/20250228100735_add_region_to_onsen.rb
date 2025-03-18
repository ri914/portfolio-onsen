class AddRegionToOnsen < ActiveRecord::Migration[7.1]
  def change
    add_column :onsens, :region, :string
  end
end
