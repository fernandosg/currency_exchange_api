class AddUniqueIndexToForeignExchanges < ActiveRecord::Migration[6.1]
  def change
    add_index :foreign_exchanges, :code, unique: true
  end
end
