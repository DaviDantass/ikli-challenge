class MakeUserEmailIndexCaseInsensitive < ActiveRecord::Migration[8.1]
  def change
    remove_index :users, :email
    add_index :users, "lower(email)", unique: true, name: "index_users_on_lower_email"
  end
end
