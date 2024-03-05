class AddFlowIdToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :flow_id, :integer
  end
end
