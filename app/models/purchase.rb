class Purchase < ApplicationRecord
  belongs_to :purchaser
  belongs_to :item
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
end
