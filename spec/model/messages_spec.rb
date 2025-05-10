require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'アソシエーション' do
    it 'ルームに属していること' do
      expect(described_class.reflect_on_association(:room).macro).to eq :belongs_to
    end

    it 'ユーザーに属していること' do
      expect(described_class.reflect_on_association(:user).macro).to eq :belongs_to
    end

    it '親メッセージに属すること' do
      assoc = described_class.reflect_on_association(:parent_message)
      expect(assoc.macro).to eq :belongs_to
      expect(assoc.options[:optional]).to be true
    end

    it '返信メッセージを複数持つこと' do
      expect(described_class.reflect_on_association(:replies).macro).to eq :has_many
    end
  end

  describe 'バリデーション' do
    let(:user) { create(:user) }
    let(:room) { create(:room) }

    it 'メッセージか画像があれば有効であること' do
      message = build(:message, content: 'テストメッセージ', room: room, user: user)
      expect(message).to be_valid
    end

    it 'メッセージも画像もないと無効であること' do
      message = build(:message, content: '', image: nil, room: room, user: user)
      expect(message).to be_invalid
      expect(message.errors[:base]).to include("メッセージ内容または画像を入力してください")
    end
  end

  describe '編集可能時間' do
    it '作成時に編集可能時間が30分後に設定されること' do
      message = create(:message)
      expect(message.editable_until).to be_within(5.seconds).of(30.minutes.from_now)
    end
  end

  describe '画像削除機能（remove_image）' do
    it 'remove_imageがチェックされたとき画像が削除されること' do
      message = create(:message, image: fixture_file_upload('spec/fixtures/files/sample_image.jpg', 'image/jpeg'))
      message.remove_image = '1'
      message.valid?
      expect(message.image).not_to be_attached
    end

    it 'remove_imageが空のとき画像は削除されないこと' do
      message = create(:message, image: fixture_file_upload('spec/fixtures/files/sample_image.jpg', 'image/jpeg'))
      message.remove_image = ''
      message.valid?
      expect(message.image).to be_attached
    end
  end

  describe '返信機能' do
    it '親メッセージを指定して返信を作成できること' do
      parent = create(:message)
      reply = create(:message, parent_message: parent)
      expect(reply.parent_message).to eq parent
      expect(parent.replies).to include reply
    end
  end
end
