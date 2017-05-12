class DummyAppCreateDummyModel < ActiveRecord::Migration
  def change
    create_table :dummy_model do |t|
      t.string  :type
      t.string  :name
      t.integer :age
    end
  end
end
