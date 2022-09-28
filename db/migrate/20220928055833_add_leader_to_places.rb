class AddLeaderToPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :places, :leader, :boolean, default: false, null: false
  end
end
