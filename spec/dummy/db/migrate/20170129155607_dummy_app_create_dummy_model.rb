class DummyAppCreateDummyModel < ActiveRecord::Migration[4.2]
  def change
    create_table :dummy_model do |t|
      t.string  :type
      t.string  :name
      t.integer :age
    end
  end
end
