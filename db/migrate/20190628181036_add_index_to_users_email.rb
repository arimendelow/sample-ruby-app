class AddIndexToUsersEmail < ActiveRecord::Migration[5.2]
  def change
    # The 'add_index' method is adding an index on the email column of the user's table.
    # The index itself doesn't enforce uniqueness, but the option 'unique: true' does
    add_index :users, :email, unique: true
  end
end
