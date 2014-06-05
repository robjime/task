class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.integer :user_id
      t.integer :client_id
      t.string :authentication_token

      t.timestamps
    end
  end
end
