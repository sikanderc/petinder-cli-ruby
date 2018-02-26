require "pry"
require "colorize"

class CommandLineInterface

  def valid_account
    puts "Please enter your name:".colorize(:color => :white, :background => :blue)
    name = gets.chomp.capitalize
  end

  def welcome(name)
    puts "Welcome to PeTinder, #{name}! Lets find your perfect partner! \nPlease enter your zipcode and we'll get started.".colorize(:color => :white, :background => :blue)
    zipcode = gets.chomp
  end

  def create_user(name, zipcode)
      current_user = User.find_or_create_by(userName: name, userZipCode: zipcode)
  end

  def get_animal_type(zipcode)
    puts "Thank you for input! Please enter the animal type you're interested in. \n(cat, dog, horse, reptile, rabbit, pig, or barnyard)".colorize(:color => :white, :background => :blue)
    animal_type = gets.chomp.downcase
    # if animalType != "cat" || "dog" || "horse" || "reptile" || "rabbit" || "pig" || "barnyard"
    #   puts "please enter a valid animal type"
    #   retry
    # end
  end

  def get_sex
    puts "What gender of animal would you prefer? Write 'M' for male or 'F' for female.".colorize(:color => :white, :background => :blue)
    animal_gender = gets.chomp.upcase
  end

  def get_size
    puts "What size animal are you interested in? Options are: 'S', 'M', 'L', or 'XL'.".colorize(:color => :white, :background => :blue)
    animal_size = gets.chomp.upcase
  end

  def availability_message_holder
    availability_messages = ["Waiting for you...", "All yours, baby.", "Will dance for food!", "Take me home!!!!", "Will not show up drunk to your house at 3AM crying, asking for you to let me in. Will probably show up crying asking for you to let me in.", "I'm a fun-loving animal with absolutely no interest in murder.", "If you can't offer me something, GTFO.", "Free the nipple."]
    pet_availability = availability_messages.sample
  end

  def find_random_pet(animal_type, zipcode, animal_gender, animal_size)
    petfinder = Petfinder::Client.new('acc62e2c10e9df251207a7e3a13cd91f', '693cc2fba0334d6949234494055b09f1')
    options = {animal: animal_type, location: zipcode, sex: animal_gender, size: animal_size}
    new_pet = petfinder.random_pet(options)
  end

  def find_shelter_for_pet(new_pet)
    petfinder = Petfinder::Client.new('acc62e2c10e9df251207a7e3a13cd91f', '693cc2fba0334d6949234494055b09f1')
    searched_shelter = petfinder.shelter(new_pet.shelter_id)
  end

  def print_animal_info(new_pet, searched_shelter, pet_availability)
    puts "Our experts have found the perfect pet for you! Its information is below!".colorize(:color => :white, :background => :blue)
    puts "Name: #{new_pet.name}".colorize(:color => :green)
    puts "Breed: #{new_pet.breeds.first}".colorize(:color => :green)
    puts "Size: #{new_pet.size}".colorize(:color => :green)
    puts "Sex: #{new_pet.sex}".colorize(:color => :green)
    puts "Shelter: #{searched_shelter.name}".colorize(:color => :green)
    puts "Availability: #{pet_availability}".colorize(:color => :green)
    puts "Would you like to add this pet to your matches? 'Y' or 'N'".colorize(:color => :white, :background => :blue)
  end

  def create_pet(new_pet, animal_type, animal_gender, searched_shelter)
    puts "Added to your matches!".colorize(:color => :white, :background => :blue)
    animal = Pet.find_or_create_by(animalName: new_pet.name, animalType: animal_type, animalBreed: new_pet.breeds.first, animalGender: animal_gender, shelterName: searched_shelter.name)
  end

  def get_selections_from_user(animal, current_user)
    Selection.find_or_create_by(petId: animal.id, userId: current_user.id)
  end

  def get_match_response
    puts "Congratulations on matching with this animal! Type 'more' to see more animals or type 'matches' to see your matches!".colorize(:color => :white, :background => :blue)
  end

  def view_matches(current_user)
    all_matches = Selection.where(userId: current_user.id)
    # binding.pry
    petInfo = all_matches.collect do |matches|
      Pet.find(matches.petId)
    end
    petInfo.each { |e| puts "Pet ID: #{e[:id]} \nName: #{e[:animalName]} \nType: #{e[:animalType]} \nBreed: #{e[:animalBreed]} \nGender: #{e[:animalGender]} \nShelter: #{e[:shelterName]}\n-------------------------------\n".colorize(:color => :green) }
  end

  def ask_about_adoption
    puts "If you would like to choose an animal for adoption please enter 'Adopt'. If not, press enter to exit the program!".colorize(:color => :white, :background => :blue)
  end

  def get_adoption_selection(current_user)
    puts "Please enter the ID of the pet you would like to adopt:".colorize(:color => :white, :background => :blue)
    adopted_pet = gets.chomp.upcase
    adoption = Selection.find_by(petId: adopted_pet, userId: current_user.id)
    adoption.update(adoptionStatus: true)
    adoption_matches = Selection.where(userId: current_user.id, adoptionStatus: true)
    adoptedPets = adoption_matches.collect do |matches|
      Pet.find(matches.petId)
    end
    adoptedPets.each { |e| puts "Name: #{e[:animalName]} \nType: #{e[:animalType]} \nBreed: #{e[:animalBreed]} \nGender: #{e[:animalGender]} \n-------------------------------\n".colorize(:color => :green) }
  end

end
