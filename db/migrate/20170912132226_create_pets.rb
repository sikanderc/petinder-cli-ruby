class CreatePets < ActiveRecord::Migration[5.0]
  def change
    create_table :pets do |t|
      t.string :animalName
      t.string :animalType
      t.string :animalBreed
      t.string :animalGender
      t.string :shelterName
    end
  end
end
