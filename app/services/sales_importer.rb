require "csv"

class SalesImporter
  EXPECTED_HEADERS = [
    "purchaser name", "item description", "item price",
    "purchase count", "merchant address", "merchant name"
  ].freeze

  class InvalidFileError < StandardError; end

  def initialize(file)
    @file = file
  end

  def call
    total = 0.to_d

    ActiveRecord::Base.transaction do
      rows = CSV.read(@file.path, headers: true, col_sep: "\t")
      raise InvalidFileError, "Cabeçalho do arquivo é inválido" unless rows.headers == EXPECTED_HEADERS

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
  rescue CSV::MalformedCSVError, ArgumentError, ActiveRecord::RecordInvalid => error
    raise InvalidFileError, "Arquivo inválido: #{error.message}"
  end
end
