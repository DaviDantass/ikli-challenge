class Item < ApplicationRecord
  belongs_to :merchant
  has_many :purchases, dependent: :restrict_with_error
  validates :description, presence: true
  validates :description, uniqueness: { scope: :merchant_id }
end
