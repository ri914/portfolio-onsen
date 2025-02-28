require 'rails_helper'

RSpec.describe '新規投稿ページ', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:water_quality) { WaterQuality.create(name: '単純温泉') }

  before do
    sign_in user
  end

  describe '新しい温泉を投稿する' do
    it '温泉を投稿できる' do
      visit new_onsen_path

      fill_in '温泉地の名称', with: '箱根温泉'
      select '神奈川県', from: '都道府県'
      check '単純温泉', visible: :all
      click_button '投稿'

      expect(page).to have_content '温泉情報が作成されました。'
      expect(page).to have_content '箱根温泉'
    end
  end
end
