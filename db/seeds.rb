30.times do
  name = Faker::Food.dish
  email = Faker::Internet.email
  password = "password"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now
  )
end

users = User.all
30.times do
  content = Faker::LeagueOfLegends.masteries
  users.each {|user| user.microposts.create!(content: content)}
end

# User.create(
#   name: "Tu Nguyen",
#   email: "tuunguyen2795@gmail.com",
#   password: "password",
#   password_confirmation: "password",
#   activated: true,
#   admin: true,
#   activated_at: Time.zone.now
# )

# users = User.all
# user = User.first
# following = users[2..20]
# followers = users[3..25]
# following.each {|followed| user.follow(followed)}
# followers.each {|follower| follower.follow(user)}
