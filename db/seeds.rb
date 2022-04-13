# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'


Account.destroy_all
Property.destroy_all

Account.create!(id: 1, email: "test1@email.com", password: "password")
Account.create!(id: 2, email: "test2@email.com", password: "password")
Account.create!(id: 3, email: "test3@email.com", password: "password")
Account.create!(id: 4, email: "test4@email.com", password: "password")

puts "creating properties..."
price_array = [200000, 500000, 1000000, 3000000]
name_array = ['New Build', 'Historic Villa', 'Cozy Apartment']
20.times do 
    country = Faker::Address.country
    bedrooms = rand(1..4)
    bathrooms = rand(1..4)

    price = price_array.sample 
    name = name_array.sample
    Property.create( account_id: rand(1..4), country: country, price: price, bedrooms: bedrooms,
                    bathrooms: bathrooms, name: name  )
end