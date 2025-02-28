# spec/factories/onsens.rb
FactoryBot.define do
  factory :onsen do
    name { "箱根温泉" }
    location { "神奈川県" }
    description { "素晴らしい温泉です。" }

    # 既存の泉質を自動的に作成する
    after(:create) do |onsen|
      create_list(:water_quality, 12) unless WaterQuality.count > 0 # 泉質が既に存在しない場合のみ作成
      onsen.water_qualities << WaterQuality.all # すべての泉質を関連付ける
    end

    after(:build) do |onsen|
      if onsen.images.blank?
        onsen.images.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample_image.jpg')), filename: 'sample_image.jpg',
                            content_type: 'image/jpeg')
      end
    end
  end
end
