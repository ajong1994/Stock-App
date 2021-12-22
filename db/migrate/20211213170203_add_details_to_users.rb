class AddDetailsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :full_name, :string, null:false
    add_column :users, :type, :string, null: false, default: "Client"
    add_column :users, :registration_status, :string, null:false, default: "Pending"
    add_column :users, :balance, :decimal, precision: 10, scale:2, default: 0.0
  end
end