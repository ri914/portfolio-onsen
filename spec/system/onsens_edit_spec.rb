require 'rails_helper'

RSpec.describe "温泉情報編集ページ", type: :system do
  let!(:user) { create(:user) }
  let!(:water_quality) { WaterQuality.create(name: '単純温泉') }
  let!(:onsen) { create(:onsen, user: user, water_quality_ids: [water_quality.id]) }

  before do
    sign_in user
  end

  describe "温泉情報の編集" do
    before do
      visit edit_onsen_path(onsen)
    end

    it "フォームが正しく表示されること" do
      expect(page).to have_content("温泉情報を編集")
      expect(page).to have_field("温泉地の名称", with: onsen.name)
      expect(page).to have_select("都道府県", selected: onsen.location)
      expect(page).to have_checked_field(water_quality.name)
    end

    it "温泉情報を正しく更新できること" do
      fill_in "温泉地の名称", with: "新しい温泉名"
      select "神奈川県", from: "都道府県"
      uncheck water_quality.name
      check '単純温泉', visible: :all
      attach_file "onsen[images][]", Rails.root.join('spec/fixtures/files/sample_image.jpg')

      click_button "更新"

      expect(page).to have_content("温泉情報が更新されました。")
      expect(page).to have_content("新しい温泉名")
      expect(page).to have_content("神奈川県")
      expect(page).to have_content("単純温泉")
    end

    it "無効な入力でエラーが表示されること" do
      fill_in "温泉地の名称", with: ""
      click_button "更新"

      expect(page).to have_content("エラー!")
      expect(page).to have_content("Name can't be blank")
    end

    it "温泉を削除できること" do
      expect do
        click_button 'この温泉を削除'
      end.to change(Onsen, :count).by(-1)

      expect(page).to have_content("温泉情報が削除されました。")
    end
  end
end
