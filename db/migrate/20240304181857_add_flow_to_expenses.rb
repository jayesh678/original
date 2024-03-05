class AddFlowToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_reference :expenses, :flow, null: false, foreign_key: true
  end
end
