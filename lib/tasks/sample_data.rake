namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(name:     "Example User",
                       email:    "trunghung5055@gmail.com",
                       password: "000000",
                       password_confirmation: "000000",
                       admin: true,
                       status: "online")
  20.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    status_ol = "online"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password,
                 status: status_ol)
  end

  20.times do |n|
    name  = Faker::Name.name
    email = "exampleo-#{n+1}@yahoo.org"
    status_of = "offline"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password,
                 status: status_of)           
  end
end

def make_microposts
  users = User.all.limit(6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end