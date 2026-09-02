class Purchaser < ApplicationRecord
    has_many :purchases, dependent: :restrict_with_error
    validates :name, presence: true, uniqueness: true
end
