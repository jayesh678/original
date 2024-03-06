class AddCompanyIdToFlows < ActiveRecord::Migration[7.1]
  def change
    add_reference :flows, :company, null: false, foreign_key: true
  end
end
