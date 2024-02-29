class RemoveColumnInitiatorIdFromExpenses < ActiveRecord::Migration[7.1]
  def change
    remove_column :Expenses, :initiator_id, :integer
  end
end
