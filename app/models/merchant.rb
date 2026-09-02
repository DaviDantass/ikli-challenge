class Merchant < ApplicationRecord
    has_many :items, dependent: :restrict_with_error
    validates :name, :address, presence: true
    validates :name, uniqueness: { scope: :address }
end
