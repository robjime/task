class AddAuthtokenindexToTokens < ActiveRecord::Migration
  def change
    add_index :tokens, :authentication_token
  end
end