class AddFailedAtToCurrencyApiCallsLogs < ActiveRecord::Migration[6.1]
  def change
    add_column :currency_api_calls_logs, :failed_at, :datetime
  end
end
