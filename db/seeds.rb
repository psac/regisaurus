# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'creating user'
User.create({email: 'psac@psac.com', password: 'psac', password_confirmation: 'psac'})

#puts 'creating shooters'
#100.times do
#  shooter = {
#      first_name: Faker::Name.first_name,
#      last_name: Faker::Name.last_name,
#      age: Shooter.ages.sample,
#      gender: %w{MALE FEMALE}.sample,
#      agc_number: rand(100) > 75 ? (rand(1000) + 100).to_s : '',
#      uspsa_number: %w{A TY FY L}.sample + (rand(10000) + 500).to_s,
#      member: rand(100) > 75 ? Date.new.year : ''
#  }
#  Shooter.create shooter
#end
#
puts 'creating match'
match = {
    club: 'PSAC',
    title: 'todays match',
    active: true
}
match = Match.create match
#
#puts 'creating registrations'
#34.times do
#  registration = {
#      shooter: Shooter.all.sample,
#      power_factor: 'MAJOR',
#      squad: (1..4).to_a.sample,
#      division: %w{LIMITED OPEN PRODUCTION SINGLE\ STACK}.sample
#  }
#  match.registrations.create registration
#end