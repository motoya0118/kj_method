class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.references :small_group, null: false
      t.string :content, default: 'Card'
      t.integer :position, null: false , default:0
      t.boolean :edit, null: false, default: false

      t.timestamps
    end
  end
end
