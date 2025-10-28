class RemoveColumnPasswordDigestFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :password_digest
  end
end
