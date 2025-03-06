require 'rails_helper'

RSpec.describe '温泉検索', type: :system do
  let!(:user) { create(:user) }
  let!(:water_quality) { WaterQuality.create(name: '単純温泉') }
  let!(:onsen1) { create(:onsen, user: user, water_quality_ids: [water_quality.id]) }
  let!(:onsen2) { create(:onsen, :in_aomori, user: user, water_quality_ids: [water_quality.id]) }

  describe 'ナビメニューのキーワード検索' do
    before do
      sign_in user
      visit home_index_path
    end

    context 'キーワード未入力で検索ボタンを押した場合', js: true do
      it 'アラートが表示されること' do
        find('.btn-primary').click
        expect(page.accept_alert).to eq 'キーワードを入力してください。'
      end
    end

    context 'キーワードを入力して検索した場合' do
      it '該当する温泉が表示されること' do
        fill_in 'キーワードを入力...', with: '箱根'
        find('.btn-primary').click
        expect(page).to have_content '箱根温泉'
        expect(page).not_to have_content '酸ヶ湯温泉'
      end
    end

    context '部分一致の検索結果が都道府県順に並んでいること' do
      before do
        fill_in 'キーワードを入力...', with: '温泉'
        find('.btn-primary').click
      end

      it '青森県→神奈川県の順に表示されること' do
        onsens = all('.card-title').map(&:text)
        expect(onsens).to eq ['酸ヶ湯温泉', '箱根温泉']
      end
    end
  end

  describe 'トップページでログインしていない状態で検索する場合' do
    before do
      visit root_path
      fill_in 'キーワードを入力', with: '箱根'
      find('#search-btn').click
    end

    context 'キーワードを入力して検索ボタンを押した場合', js: true do
      it "ゲストユーザーとしてログインできること" do
        expect(page).to have_content("ゲストユーザーとしてログインしました。")
      end

      it "該当する温泉が表示されること" do
        expect(page).to have_content '箱根温泉'
        expect(page).not_to have_content '酸ヶ湯温泉'
      end
    end
  end
end
