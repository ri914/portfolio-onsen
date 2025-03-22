require 'rails_helper'

RSpec.describe "Onsens Weather", type: :system do
  include Devise::Test::IntegrationHelpers

  let!(:user) { create(:user) }
  let!(:water_quality) { WaterQuality.create(name: '単純温泉') }
  let!(:water_quality_2) { WaterQuality.create(name: '硫黄泉') }
  let!(:onsen1) { create(:onsen, user: user, water_quality_ids: [water_quality.id]) }
  let!(:onsen2) { create(:onsen, :in_aomori, user: user, water_quality_ids: [water_quality_2.id]) }

  let!(:onsen_with_clear_weather) { onsen1 }
  let!(:onsen_with_rainy_weather) { onsen2 }

  before do
    sign_in user

    allow(WeatherService).to receive(:fetch_weather_for).with("神奈川県").and_return({
      temperature: 25, description: "晴天", icon: "01d",
    })
    allow(WeatherService).to receive(:fetch_weather_for).with("青森県").and_return({
      temperature: 22, description: "雨", icon: "10d",
    })
  end

  describe "露天風呂日和の温泉ページ" do
    before do
      visit roten_onsens_path
    end

    it "晴天の温泉だけが表示される" do
      expect(page).to have_content(onsen_with_clear_weather.name)
      expect(page).not_to have_content(onsen_with_rainy_weather.name)
    end

    it "晴天の温泉に気温と天気情報が表示される" do
      expect(page).to have_content("気温: 25°C")
      expect(page).to have_content("天気: 晴天")
    end
  end

  describe "温泉詳細ページ" do
    before do
      visit onsen_path(onsen_with_clear_weather)
    end

    it "温泉の詳細ページに天気情報が表示される" do
      expect(page).to have_content("気温: 25°C")
      expect(page).to have_content("晴天")
      expect(page).to have_css("img[src*='01d']")
    end

    it "天気情報が取得できない場合、エラーメッセージが表示される" do
      allow(WeatherService).to receive(:fetch_weather_for).and_return(nil)
      visit onsen_path(onsen_with_clear_weather)
      expect(page).to have_content("天気情報が取得できませんでした。")
    end
  end
end
