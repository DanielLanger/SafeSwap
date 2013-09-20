class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :picture, :string
    add_column :users, :phone, :string
    add_column :users, :balance, :float
  end
end
