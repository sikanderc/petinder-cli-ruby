require 'bundler'
Bundler.require


petfinder = Petfinder::Client.new('acc62e2c10e9df251207a7e3a13cd91f', '693cc2fba0334d6949234494055b09f1')

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'

require_relative "../app/pet.rb"
require_relative "../app/selection.rb"
require_relative "../app/user.rb"
