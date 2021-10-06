class AddNullToConstants < ActiveRecord::Migration[6.1]
  def change
    change_column_null :links, :name, false
    change_column_null :links, :url, false
    change_column_null :rewards, :title, false
    change_column_null :votes, :value, false
  end
end
