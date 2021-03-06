class AddStateWatersReferenceToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :state_waters, :string
    add_foreign_key :locations, :states, column: :state_waters, primary_key: :name
  end
end
