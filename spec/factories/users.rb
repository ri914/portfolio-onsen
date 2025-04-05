FactoryBot.define do
  factory :user do
    name { "Test User" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password" }
  end

  factory :guest, parent: :user do
    role { "guest" }
  end
end
