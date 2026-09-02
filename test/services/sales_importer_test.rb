require "test_helper"

class SalesImporterTest < ActiveSupport::TestCase
  test "imports normalized sales and returns gross income" do
    File.open(file_fixture("example_input.tab")) do |file|
      total = nil

      assert_difference -> { Purchase.count } => 4,
                        -> { Purchaser.count } => 4,
                        -> { Merchant.count } => 3,
                        -> { Item.count } => 3 do
        total = SalesImporter.new(file).call
      end

      assert_equal 95.to_d, total
    end
  end
end
