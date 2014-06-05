class AddUidindexToEvents < ActiveRecord::Migration
  def change
    add_index "events", ["uid"], name: "index_timeszones_on_uid", using: :btree
  end
end
