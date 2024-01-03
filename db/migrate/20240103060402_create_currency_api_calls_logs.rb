class CreateCurrencyApiCallsLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :currency_api_calls_logs do |t|
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end
