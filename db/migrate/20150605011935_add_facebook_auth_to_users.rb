class AddFacebookAuthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token, :string
    add_column :users, :expiration, :datetime
    add_column :users, :name, :string
  end
end
