class CreateSelections < ActiveRecord::Migration[5.0]
  def change
    create_table :selections do |t|
      t.integer :petId
      t.integer :userId
      t.boolean :adoptionStatus
    end
  end
end
