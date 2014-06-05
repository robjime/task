class AddUseridindexToEvents < ActiveRecord::Migration
  def change
    add_index "events", ["user_id"], name: "index_timeszones_on_user_id", using: :btree
  end
end
