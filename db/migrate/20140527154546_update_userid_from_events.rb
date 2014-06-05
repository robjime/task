class UpdateUseridFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :user_id
    add_column :events, :user_id, :integer
    add_index "events", ["user_id"], name: "index_timeszones_on_user_id", using: :btree
  end
end
