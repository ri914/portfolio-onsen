# spec/system/onsens_spec.rb
require 'rails_helper'

RSpec.describe "温泉一覧ページ", type: :system do
  let!(:user) { create(:user) }
  let!(:water_quality) { WaterQuality.create(name: '単純温泉') }
  let!(:onsen1) { create(:onsen, user: user, water_quality_ids: [water_quality.id]) }
  let!(:onsen2) { create(:onsen, :in_aomori, user: user, water_quality_ids: [water_quality.id]) }

  before do
    sign_in user
  end

  describe "全国の温泉の一覧表示" do
    it "全国の温泉が正しく表示されること" do
      visit onsens_path

      expect(page).to have_content(onsen1.name)
      expect(page).to have_content(onsen1.location)
      expect(page).to have_css("img[src*='sample_image.jpg']")
      expect(page).to have_content(onsen2.name)
      expect(page).to have_content(onsen2.location)
    end
  end

  describe "地方区分ごとの温泉一覧表示" do
    it "指定された地方の温泉が正しく表示されること" do
      visit region_onsens_path(region: "関東")

      expect(page).to have_content(onsen1.name)
      expect(page).to have_content(onsen1.location)
      expect(page).not_to have_content(onsen2.name)
    end
  end

  describe "都道府県の温泉一覧表示" do
    it "指定された都道府県の温泉が正しく表示されること" do
      visit prefecture_onsens_path(region: "関東", prefecture: "神奈川県")

      expect(page).to have_content(onsen1.name)
      expect(page).to have_content(onsen1.location)
      expect(page).not_to have_content(onsen2.name)
    end
  end
end
