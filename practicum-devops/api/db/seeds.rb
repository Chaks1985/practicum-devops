# frozen_string_literal: true
require 'faker'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless User.count > 0
  25.times do
    User.create({
      name: Faker::Name.name_with_middle,
      ocupation: Faker::Job.title,
      email: Faker::Internet.free_email,
      bio: Faker::Games::WorldOfWarcraft.quote,
      avatar_url: Faker::Avatar.unique.image
    })
  end
end
