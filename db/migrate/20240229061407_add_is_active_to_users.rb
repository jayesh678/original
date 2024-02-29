class AddIsActiveToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :Users, :is_active, :boolean, default: true
  end
end
