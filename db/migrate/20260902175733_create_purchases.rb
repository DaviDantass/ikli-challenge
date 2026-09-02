class CreatePurchases < ActiveRecord::Migration[8.1]
  def change
    create_table :purchases do |t|
      t.references :purchaser, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.decimal :unit_price, precision: 10, scale: 2, null: false
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
