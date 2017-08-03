# 30.times do
#   name = Faker::Superhero.name
#   email = Faker::Internet.email
#   password = "password"
#   User.create!(
#     name: name,
#     email: email,
#     password: password,
#     password_confirmation: password,
#     activated: true,
#     activated_at: Time.zone.now
#   )
# end

# users = User.order(created_at: :desc).take(6)
# 30.times do
#   content = Faker::LeagueOfLegends.masteries
#   users.each {|user| user.microposts.create!(content: content)}
# end

User.create(
  name: "Tu Nguyen",
  email: "tuunguyen2795@gmail.com",
  password: "password",
  password_confirmation: "password",
  activated: true,
  admin: true,
  activated_at: Time.zone.now
)
