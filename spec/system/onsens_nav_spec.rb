require 'rails_helper'

RSpec.describe "温泉ナビゲーション", type: :system do
  let!(:user) { create(:user) }
  let!(:water_quality) { WaterQuality.create(name: '単純温泉') }
  let!(:onsen1) { create(:onsen, user: user, water_quality_ids: [water_quality.id]) }
  let!(:onsen2) { create(:onsen, :in_aomori, user: user, water_quality_ids: [water_quality.id]) }

  before do
    sign_in user
  end

  describe "地域ナビゲーション" do
    it "地域リンクが正しく表示され、クリックできること" do
      visit onsens_path

      expect(page).to have_link('トップ', href: onsens_path)
      expect(page).to have_link('北海道', href: region_onsens_path(region: '北海道'))
      expect(page).to have_link('東北', href: region_onsens_path(region: '東北'))
      expect(page).to have_link('関東', href: region_onsens_path(region: '関東'))
      expect(page).to have_link('中部', href: region_onsens_path(region: '中部'))
      expect(page).to have_link('近畿', href: region_onsens_path(region: '近畿'))
      expect(page).to have_link('中国', href: region_onsens_path(region: '中国'))
      expect(page).to have_link('四国', href: region_onsens_path(region: '四国'))
      expect(page).to have_link('九州・沖縄', href: region_onsens_path(region: '九州・沖縄'))

      click_link '関東'
      expect(page).to have_content('関東の温泉')

      click_link '東北'
      expect(page).to have_content('東北の温泉')
    end

    it "都道府県リンクが正しく表示され、クリックできること" do
      visit region_onsens_path(region: '関東')

      expect(page).to have_link('神奈川県', href: prefecture_onsens_path(region: '関東', prefecture: '神奈川県'))
      expect(page).to have_link('青森県', href: prefecture_onsens_path(region: '東北', prefecture: '青森県'))

      click_link '神奈川県'
      expect(page).to have_content('神奈川県の温泉')
    end
  end
end
