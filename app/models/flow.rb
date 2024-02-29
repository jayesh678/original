class Flow < ApplicationRecord
  has_many :expenses, dependent: :destroy
  
  def self.create_default_flow
    Flow.create(default: true)
  end
end
