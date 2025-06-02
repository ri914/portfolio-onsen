require 'rails_helper'

RSpec.describe "ブックマーク機能", type: :system do
  let!(:user) { create(:user) }
  let!(:water_quality) { WaterQuality.create(name: '単純温泉') }
  let!(:onsen) { create(:onsen, user: user, water_quality_ids: [water_quality.id]) }

  before do
    sign_in user
  end

  describe "ブックマーク" do
    it "ブックマークできること" do
      visit onsen_path(onsen)
      expect(page).not_to have_css('.save-button.saved')

      find("#bookmark-button-#{onsen.id}").click

      click_link '保存済み'
      expect(page).to have_content('保存済みの温泉')
      expect(page).to have_selector("i.fa-bookmark")
    end

    it "ブックマークを解除できること" do
      visit onsen_path(onsen)
      find("#bookmark-button-#{onsen.id}").click
      find("#bookmark-button-#{onsen.id}").click

      expect(page).not_to have_content('保存済みの温泉')
      expect(page).to have_selector("i.fa-bookmark-o")
    end
  end
end
