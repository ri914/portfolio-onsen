require 'rails_helper'

RSpec.describe Room, type: :model do
  describe 'アソシエーション' do
    it '温泉（onsen）に属していること' do
      expect(Room.reflect_on_association(:onsen).macro).to eq(:belongs_to)
    end

    it 'メッセージ（messages）を複数持つこと' do
      assoc = Room.reflect_on_association(:messages)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'メッセージの並び順' do
    it '作成日時が昇順で並んでいること' do
      room = create(:room)
      msg1 = create(:message, room: room, created_at: 2.days.ago)
      msg2 = create(:message, room: room, created_at: 1.day.ago)
      msg3 = create(:message, room: room, created_at: Time.current)

      expect(room.messages).to eq([msg1, msg2, msg3])
    end
  end

  describe '依存関係' do
    it 'ルームを削除すると関連するメッセージも削除されること' do
      room = create(:room)
      create_list(:message, 3, room: room)

      expect { room.destroy }.to change { Message.count }.by(-3)
    end
  end
end
