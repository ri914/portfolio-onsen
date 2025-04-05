require 'rails_helper'

RSpec.describe "Rooms", type: :system do
  let!(:user) { create(:user) }
  let!(:water_quality) { WaterQuality.create(name: '単純温泉') }
  let!(:onsen) { create(:onsen, user: user, water_quality_ids: [water_quality.id]) }
  let!(:room) { create(:room, onsen: onsen) }

  before do
    sign_in user
  end

  describe "掲示板の表示" do
    let!(:message) { create(:message, room: room, user: user, content: "テストメッセージ") }

    it "掲示板の投稿一覧が表示されること" do
      visit onsen_room_path(onsen)

      expect(page).to have_content("#{onsen.name}の掲示板")
      expect(page).to have_content("テストメッセージ")
      expect(page).to have_selector(".message-container", count: 1)
    end

    it "自分の投稿には編集リンクが表示されること（編集可能時間内）" do
      message.update(editable_until: 30.minutes.from_now)

      visit onsen_room_path(onsen)

      within("#message-#{message.id}") do
        expect(page).to have_link("編集")
        expect(page).to have_selector(".edit-time-remaining")
      end
    end
  end

  describe "メッセージの投稿" do
    let!(:message) { create(:message, room: room, user: user, content: "テストメッセージ") }

    it "新しい投稿を送信できること" do
      visit onsen_room_path(onsen)

      fill_in "message_content", with: "新しいメッセージ"
      click_button "送信"

      expect(page).to have_content("新しいメッセージ")
    end

    it "画像付きの投稿を送信できること" do
      visit onsen_room_path(onsen)

      fill_in "message_content", with: "画像付きメッセージ"
      attach_file("image-upload", Rails.root.join("spec/fixtures/files/sample_image.jpg"))
      click_button "送信"

      expect(page).to have_content("画像付きメッセージ")
      expect(page).to have_selector("img.uploaded-image")
    end
  end

  describe "投稿の編集" do
    context "自分の投稿の編集" do
      let!(:message) { create(:message, room: room, user: user, content: "テストメッセージ") }

      it "ユーザーは自分の投稿を編集できること" do
        visit onsen_room_path(onsen)
        click_link "編集", href: edit_message_onsen_room_path(onsen, message)

        expect(page).to have_current_path(edit_message_onsen_room_path(onsen, message))
        fill_in "message_content", with: "新しい内容"
        click_button "更新"

        expect(page).to have_content("新しい内容")
        expect(page).to have_content("メッセージを編集しました。")
      end

      it "編集期限を過ぎると編集リンクが表示されないこと" do
        message.update(editable_until: 1.minute.ago)

        visit onsen_room_path(onsen)

        expect(page).not_to have_content("編集")
      end
    end
    context "他のユーザーのメッセージを編集しようとした場合" do
      let!(:other_user) { create(:user, email: 'other@example.com') }
      let!(:other_message) { create(:message, room: room, user: other_user, content: "他ユーザーのメッセージ") }

      it "編集リンクが表示されないこと" do
        visit onsen_room_path(onsen)

        expect(page).not_to have_content("編集")
      end
    end
  end
end
