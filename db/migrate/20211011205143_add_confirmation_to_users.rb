class AddConfirmationToUsers < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      # For confirmable
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email       # Only if using reconfirmable
    end

    add_index :users, :confirmation_token, unique: true
    execute("UPDATE users SET confirmed_at = NOW()")
  end
end
