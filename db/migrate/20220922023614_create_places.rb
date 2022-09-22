class CreatePlaces < ActiveRecord::Migration[6.1]
  def change
    create_table :places do |t|
      t.boolean :public , null: false, default: false
      t.references :thema, null: false, foreign_key: true

      t.timestamps
    end
  end
end
