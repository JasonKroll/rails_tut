namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users2
    make_microposts2
    # make_relationships
  end
end
def make_users
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
    50.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end  
end

def make_users2
    User.create!(name: "Jason Kroll",
                 email: "krolly@gmail.com",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
    User.create!(name: "Jessie",
                 email: "jessie@example.com",
                 password: "password",
                 password_confirmation: "password",
                 admin: true)
    User.create!(name: "Sam",
                 email: "Sam@example.com",
                 password: "password",
                 password_confirmation: "password",
                 admin: true)
end

def make_microposts2
  jessie = User.find_by_email("jessie@example.com")
  sam = User.find_by_email("sam@example.com")
  sam.microposts.create(content: "That damn mailman is back! #hatethatguy")
  User.find_by_email("krolly@gmail.com").microposts.create(content: "SAM! Shut Up!")
  jessie.microposts.create(content: "The other one is barking. AGAIN!")
  sam.microposts.create(content: "What time is it? I'm sure it's dinner time!")
  jessie.microposts.create(content: "Man. I. AM. HUNGRY.")
  jessie.microposts.create(content: "Seriously! When is this guy going to give me my dinner!")
  User.find_by_email("krolly@gmail.com").microposts.create(content: "Jessie! No yet. At least an hour!")
end

def make_microposts
  users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each do |user|
        user.microposts.create!(content: content)
      end
    end
end

def make_relationships
  users = User.all
  user = User.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end

