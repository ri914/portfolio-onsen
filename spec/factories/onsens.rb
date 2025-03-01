FactoryBot.define do
  factory :onsen do
    association :user
    name { '箱根温泉' }
    location { '神奈川県' }
    region { '関東' }
    water_quality_ids { [] }

    after(:build) do |onsen|
      onsen.images.attach(
        io: File.open(Rails.root.join('spec/fixtures/files/sample_image.jpg')),
        filename: 'sample_image.jpg',
        content_type: 'image/jpeg'
      )
    end

    trait :in_aomori do
      name { '酸ヶ湯温泉' }
      location { '青森県' }
      region { '東北' }
    end
  end
end
