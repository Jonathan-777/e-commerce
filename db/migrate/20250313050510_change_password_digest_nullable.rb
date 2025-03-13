class ChangePasswordDigestNullable < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :password_digest, :string, null: true

  end
end
