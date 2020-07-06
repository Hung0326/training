class AddIndexToTableMicroposts < ActiveRecord::Migration
  def change
    add_index :microposts, [:user_id, :created_at]
    #Ex:- add_index("admin_users", "username")
  end
end
