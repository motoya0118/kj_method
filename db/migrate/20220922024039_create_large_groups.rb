class CreateLargeGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :large_groups do |t|
      t.references :place, null: false, foreign_key: true
      t.string :name , default: 'LargeGroup'
      t.integer :position, default:0
      t.boolean :edit, default: false

      t.timestamps
    end
  end
end
