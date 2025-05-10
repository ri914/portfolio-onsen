require 'rails_helper'

RSpec.describe 'モデルのバリデーションとアソシエーション', type: :model do
  describe Onsen do
    let(:user) { User.create(email: "test@example.com", password: "password") }

    describe "バリデーション" do
      it "有効な属性を持つ場合は有効であること" do
        onsen = Onsen.new(name: "箱根温泉郷", location: "神奈川県", user: user)
        expect(onsen).to be_valid
      end

      it "名前がない場合は無効であること" do
        onsen = Onsen.new(name: nil, user: user)
        expect(onsen).to_not be_valid
      end

      it "都道府県情報がない場合は無効であること" do
        onsen = Onsen.new(location: nil, user: user)
        expect(onsen).to_not be_valid
      end
    end

    describe "アソシエーション" do
      it { should belong_to(:user) }
      it { should have_many(:image_descriptions).dependent(:destroy) }
      it { should have_many_attached(:images) }
      it { should have_many(:saved_onsens).dependent(:destroy) }
      it { should have_many(:users).through(:saved_onsens) }
      it { should have_and_belong_to_many(:water_qualities) }
    end
  end

  describe SavedOnsen do
    describe "アソシエーション" do
      it { should belong_to(:user) }
      it { should belong_to(:onsen) }
    end
  end

  describe ImageDescription do
    describe "アソシエーション" do
      it { should belong_to(:onsen) }
    end
  end

  describe WaterQuality do
    describe "バリデーション" do
      it "泉質名がない場合は無効であること" do
        water_quality = WaterQuality.new(name: nil)
        expect(water_quality).to_not be_valid
      end

      it "有効な属性を持つ場合は有効であること" do
        water_quality = WaterQuality.new(name: "硫黄泉")
        expect(water_quality).to be_valid
      end
    end

    describe "アソシエーション" do
      it { should have_and_belong_to_many(:onsens) }
    end
  end
end
