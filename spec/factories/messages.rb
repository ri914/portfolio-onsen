FactoryBot.define do
  factory :message do
    content { "テストメッセージ" }
    room
    user

    editable_until { 30.minutes.from_now }
  end
end
