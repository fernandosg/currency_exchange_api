# frozen_string_literal: true

# Helper to handle the format expect for the last_updated_at column
module CurrenciesHelper
  FORMAT_DATETIME_FOR_QUERY_SEARCH = '%Y-%m-%dT%H:%M:%S'

  def format_last_updated_at(last_updated_at)
    last_updated_at.strftime('%Y-%m-%dT%H:%M:%S')
  end

  def format_date_interval_for_query(datetime)
    datetime.strftime(FORMAT_DATETIME_FOR_QUERY_SEARCH)
  end
end
