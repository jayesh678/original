class TravelExpense < ApplicationRecord
  belongs_to :user
  belongs_to :business_partner
  belongs_to :category
  has_one_attached :receipt
end
