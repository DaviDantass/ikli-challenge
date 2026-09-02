require "csv"

class SalesImporter
  def initialize(file)
    @file = file
  end

  def call
    total = 0.to_d
    rows = SalesFileValidator.new(@file).validate!

    ActiveRecord::Base.transaction do
      rows.each do |row|
        purchaser = Purchaser.find_or_create_by!(name: row["purchaser name"])

        merchant = Merchant.find_or_create_by!(
          name: row["merchant name"],
          address: row["merchant address"]
        )

        item = merchant.items.find_or_create_by!(
          description: row["item description"]
        )

        price = BigDecimal(row["item price"])
        quantity = row["purchase count"].to_i

        Purchase.create!(
          purchaser: purchaser,
          item: item,
          unit_price: price,
          quantity: quantity
        )

        total += price * quantity
      end
    end

    total
  end
end
