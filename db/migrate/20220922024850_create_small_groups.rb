class CreateSmallGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :small_groups do |t|
      t.references :large_group, null: false, foreign_key: true
      t.string :name, null:false, default: 'SmallGroup'
      t.integer :position, null: false , default:0
      t.boolean :edit, null: false, default: false

      t.timestamps
    end
  end
end
