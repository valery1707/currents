class MakeRequiredFieldsNotNullableInReports < ActiveRecord::Migration
  def change
    change_column_null(:reports, :date, false)
    change_column_null(:reports, :location_id, false)
    change_column_null(:reports, :species_id, false)
    change_column_null(:reports, :catch_keepers,false)
  end
end
