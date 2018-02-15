class CreateDummyParanoidModels < ActiveRecord::Migration
  def change
    create_table :dummy_paranoid_models do |t|
      t.string :name
      t.datetime :deleted_at
    end
  end
end
