class ChangeUidToUserId < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.rename :uid, :user_id
    end
  end
end