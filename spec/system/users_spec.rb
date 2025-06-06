require 'rails_helper'

RSpec.describe "User", type: :system do
  let!(:user) { create(:user, email: "test@example.com", password: "password") }
  let(:user_with_avatar) do
    user.avatar.attach(io: Rails.root.join('spec/fixtures/files/default_avatar.png').open, filename: 'default_avatar.png',
                       content_type: 'image/png')
    user
  end

  describe "ユーザーのマイページ表示" do
    it "ユーザーがマイページを表示できること" do
      sign_in user
      visit user_path(user)

      expect(page).to have_content("マイページ")
      expect(page).to have_content(user.name)
    end
  end

  describe "ユーザー情報の更新" do
    it "ユーザーがアイコンを削除できること" do
      sign_in user_with_avatar
      visit edit_user_registration_path

      check "user[remove_avatar]"
      fill_in "現在のパスワード", with: user.password
      click_button "変更を保存"

      expect(page).to have_content("変更が保存されました。")
      expect(user_with_avatar.reload.avatar.attached?).to be_falsey
    end

    it "ユーザーがユーザー名と紹介文を更新できること" do
      sign_in user
      visit edit_user_registration_path

      fill_in "user[name]", with: "Updated User"
      fill_in "現在のパスワード", with: user.password
      click_button "変更を保存"

      expect(page).to have_content("変更が保存されました。")
      expect(user.reload.name).to eq("Updated User")
    end
  end

  describe "ユーザー退会" do
    context "一般ユーザーの場合" do
      it "ユーザーが退会できること" do
        sign_in user
        visit user_path(user)

        click_button "退会"

        expect(page).to have_content("退会しました。")
        expect(current_path).to eq(root_path)
      end
    end
  end

  describe "ユーザーのゲストログイン" do
    it "ゲストユーザーとしてログインできること" do
      visit root_path
      first("a", text: "ゲストログイン").click

      expect(page).to have_content("ゲストユーザーとしてログインしました。")
      expect(current_path).to eq(home_index_path)
    end

    context 'ゲストユーザーとしてログインしている場合' do
      let!(:water_quality) { WaterQuality.create(name: '単純温泉') }
      let!(:onsen) { create(:onsen, user: user, water_quality_ids: [water_quality.id]) }
      let!(:guest_user) { create(:user, email: 'guest_abc123@example.com', password: 'password', name: 'ゲストユーザー') }

      before do
        sign_in guest_user
      end

      it 'ゲストユーザーはアカウント設定ページにアクセスできないこと' do
        visit edit_user_registration_path

        expect(page).to have_content('ゲストユーザーはこの機能を利用できません。')
        expect(current_path).to eq(home_index_path)
      end
    end
  end
end
