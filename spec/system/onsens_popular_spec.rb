require 'rails_helper'

RSpec.describe 'Onsen Features', type: :system do
  let!(:user) { create(:user) }
  let!(:water_quality) { WaterQuality.create(name: '単純温泉') }
  let!(:water_quality_2) { WaterQuality.create(name: '硫黄泉') }
  let!(:water_quality_3) { WaterQuality.create(name: '塩化物') }
  let!(:onsen1) { create(:onsen, user: user, water_quality_ids: [water_quality.id]) }
  let!(:onsen2) { create(:onsen, :in_aomori, user: user, water_quality_ids: [water_quality_2.id]) }
  let!(:onsen3) { create(:onsen, :in_hokkaido, user: user, water_quality_ids: [water_quality_3.id]) }

  before do
    sign_in user
  end

  describe '人気の温泉が表示されること' do
    before do
      onsen1.saved_onsens.create(user: user)
      onsen2.saved_onsens.create(user: user)
      onsen3.saved_onsens.create(user: user)
      visit home_index_path
    end

    it '温泉の名前と所在地が表示されていること' do
      expect(page).to have_content(onsen1.name)
      expect(page).to have_content(onsen2.name)
      expect(page).to have_content(onsen3.name)
      expect(page).to have_content(onsen1.location)
      expect(page).to have_content(onsen2.location)
      expect(page).to have_content(onsen3.location)
    end
  end

  describe '人気順に並ぶこと' do
    before do
      onsen2.saved_onsens.create(user: user)
      visit home_index_path
    end

    it '人気順に並んでいること' do
      expect(page.body.index(onsen2.name)).to be < page.body.index(onsen1.name)
      expect(page.body.index("🥇")).to be < page.body.index("🥈")
      expect(page.body.index("🥈")).to be < page.body.index("🥉")
    end
  end

  describe '一覧ページの並び替え機能' do
    before do
      onsen1.saved_onsens.create(user: user)
      visit onsens_path
    end

    it 'デフォルトで都道府県順に並んでいること' do
      expect(page.body.index(onsen2.name)).to be < page.body.index(onsen1.name)
      expect(page.body.index(onsen3.name)).to be < page.body.index(onsen1.name)
    end

    it 'ドロップダウンで人気順に変更できること', js: true do
      select '人気順', from: 'sort-select'
      expect(page).to have_current_path(onsens_path(sort: 'bookmarks'))
      expect(page.body.index(onsen1.name)).to be < page.body.index(onsen2.name)
    end
  end
end
