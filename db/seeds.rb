# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'


Account.destroy_all

Account.create!(id: 1, email: "test1@email.com", password: "password")
Account.create!(id: 2, email: "test2@email.com", password: "password")
Account.create!(id: 3, email: "test3@email.com", password: "password")
Account.create!(id: 4, email: "test4@email.com", password: "password")

puts "creating properties..."
20.times do 
    address = Faker::Address.full_address
    Property.create( address: address, account_id: rand(1..4))
end