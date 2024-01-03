class CreateForeignExchanges < ActiveRecord::Migration[6.1]
  def change
    create_table :foreign_exchanges do |t|
      t.string :code
      t.float :value
      t.datetime :last_updated_at

      t.timestamps
    end
  end
end
