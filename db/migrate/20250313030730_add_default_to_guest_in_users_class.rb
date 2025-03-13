class AddDefaultToGuestInUsersClass < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :guest, :boolean, default: true, null: false

  end
end
