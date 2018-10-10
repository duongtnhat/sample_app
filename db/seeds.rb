User.create! name:  "Example User",
  email: "duongtnhat@gmail.com",
  password: "12345678",
  password_confirmation: "12345678",
  admin: true,
  activated: true,
  activated_at: Time.zone.now

99.times do |n|
  name  = FFaker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create! name:  name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now
end
