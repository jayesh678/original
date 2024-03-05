class RemoveFlowIdFromExpenses < ActiveRecord::Migration[7.1]
  def up
    remove_column :expenses, :flow_id
  end

  def down
    add_column :expenses, :flow_id, :integer
  end
end
