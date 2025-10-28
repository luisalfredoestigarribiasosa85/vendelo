class MoveEmailAddressToEmail < ActiveRecord::Migration[8.0]
  def up
    return unless column_exists?(:users, :email_address)

    execute <<~SQL.squish
      UPDATE users
      SET email = email_address
      WHERE email_address IS NOT NULL
        AND email_address <> ''
        AND (email IS NULL OR email = '');
    SQL

    remove_index :users, :email_address if index_exists?(:users, :email_address)
    remove_column :users, :email_address
  end

  def down
    return if column_exists?(:users, :email_address)

    add_column :users, :email_address, :string
    add_index :users, :email_address, unique: true

    execute <<~SQL.squish
      UPDATE users
      SET email_address = email
      WHERE email IS NOT NULL
        AND email <> '';
    SQL

    change_column_null :users, :email_address, false
  end
end
