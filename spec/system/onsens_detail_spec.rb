require 'rails_helper'

RSpec.describe "温泉詳細ページ", type: :system do
  let!(:user) { create(:user) }
  let!(:water_quality) { WaterQuality.create(name: '単純温泉') }
  let!(:onsen) { create(:onsen, user: user, water_quality_ids: [water_quality.id]) }

  before do
    sign_in user
  end

  describe "温泉詳細の表示" do
    it "温泉情報が正しく表示されること" do
      visit onsen_path(onsen)

      expect(page).to have_content(onsen.name)

      expect(page).to have_content(onsen.location)

      expect(page).to have_content('泉質')
      expect(page).to have_content(water_quality.name)

      expect(page).to have_content(onsen.user.name)

      if onsen.images.attached?
        expect(page).to have_css("img[src*='#{rails_blob_path(onsen.images.first, only_path: true)}']")
      else
        expect(page).to have_css("img[src*='default_onsen_image.png']")
      end

      expect(page).to have_button('ブックマーク')

      expect(page).to have_link(href: edit_onsen_path(onsen))
    end
  end
end
