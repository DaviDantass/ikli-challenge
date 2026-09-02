class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :description, null: false
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
