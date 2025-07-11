FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    name { "Name" }
    password { Faker::Internet.password(min_length: 8, max_length: 16) }
  end
end
