class CreateThemas < ActiveRecord::Migration[6.1]
  def change
    create_table :themas do |t|
      t.string :name, null: false
      t.string :purpose
      t.boolean :lock, null:false, default: false

      t.timestamps
    end
  end
end
