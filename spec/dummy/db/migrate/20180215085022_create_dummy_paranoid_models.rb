class CreateDummyParanoidModels < ActiveRecord::Migration[4.2]
  def change
    create_table :dummy_paranoid_models do |t|
      t.string :name
      t.datetime :deleted_at
    end
  end
end
