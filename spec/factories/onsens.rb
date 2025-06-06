FactoryBot.define do
  factory :onsen do
    association :user
    name { '箱根温泉郷' }
    location { '神奈川県' }
    region { '関東' }
    water_quality_ids { [] }

    after(:build) do |onsen|
      onsen.images.attach(
        io: Rails.root.join('spec/fixtures/files/sample_image.jpg').open,
        filename: 'sample_image.jpg',
        content_type: 'image/jpeg'
      )
    end

    trait :in_aomori do
      name { '酸ヶ湯温泉' }
      location { '青森県' }
      region { '東北' }
    end

    trait :in_hokkaido do
      name { '湯の川温泉' }
      location { '北海道' }
      region { '北海道' }
    end
  end
end
