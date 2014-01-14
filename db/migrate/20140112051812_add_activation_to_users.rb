class AddActivationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activation_token, :string
    add_column :users, :active, :boolean, default: false
  end
end
