class Flow < ApplicationRecord
  has_many :expenses, dependent: :destroy
  belongs_to :company
  
  # def self.create_default_flow
  #   Flow.create(default: true)
  # end
end
