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

      fill_in 'onsen[name]', with: '箱根温泉郷'
      select '神奈川県', from: 'onsen[location]'
      check '単純温泉', visible: :all
      attach_file "onsen[images][]", Rails.root.join('spec/fixtures/files/sample_image.jpg')
      click_button '投稿'

      expect(page).to have_content '温泉情報が作成されました。'
      expect(page).to have_content '箱根温泉郷'
    end
  end
end
