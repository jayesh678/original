class RemoveColumnFromExpenses < ActiveRecord::Migration[7.1]
  def change
    remove_column :expenses, :default, :boolean
    remove_column :expenses, :subcategory, :text
    remove_column :expenses, :date, :date
  end
end
