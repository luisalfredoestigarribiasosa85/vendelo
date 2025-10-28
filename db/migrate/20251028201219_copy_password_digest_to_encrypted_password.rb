class CopyPasswordDigestToEncryptedPassword < ActiveRecord::Migration[8.0]
  def up
    unless column_exists?(:users, :encrypted_password)
      add_column :users, :encrypted_password, :string, null: false, default: ""
    end
    # Copia directa en SQL, más seguro que cargar el model
    execute <<-SQL.squish
      UPDATE users SET encrypted_password = password_digest WHERE password_digest IS NOT NULL;
    SQL
    # Asegúrate que todos tengan algún valor (si tienes usuarios sin password_digest, Devise espera cadenas aunque vacías)
    User.reset_column_information if defined?(User)
  end

  def down
    remove_column :users, :encrypted_password if column_exists?(:users, :encrypted_password)
  end
end
