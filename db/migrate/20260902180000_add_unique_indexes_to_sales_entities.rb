class AddUniqueIndexesToSalesEntities < ActiveRecord::Migration[8.1]
  def change
    add_index :purchasers, :name, unique: true
    add_index :merchants, %i[name address], unique: true
    add_index :items, %i[merchant_id description], unique: true
  end
end
