require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "有効な属性を持つ場合は有効であること" do
      user = User.new(name: "テストユーザー", email: "test@example.com", password: "password")
      expect(user).to be_valid
    end

    it "名前がない場合は無効であること" do
      user = User.new(name: nil)
      expect(user).to_not be_valid
    end

    it "メールアドレスがない場合は無効であること" do
      user = User.new(email: nil)
      expect(user).to_not be_valid
    end

    it "パスワードがない場合は無効であること" do
      user = User.new(password: nil)
      expect(user).to_not be_valid
    end

    it "重複するメールアドレスを持つ場合は無効であること" do
      User.create(email: "test@example.com", password: "password")
      user = User.new(email: "test@example.com", password: "password")
      expect(user).to_not be_valid
    end
  end

  describe "アソシエーション" do
    it { should have_many(:onsens).dependent(:destroy) }
    it { should have_many(:saved_onsens).class_name('Onsen').with_foreign_key('saved_by_user_id') }
    it { should have_one_attached(:avatar) }
  end

  describe "ゲスト" do
    it "ゲストユーザーの場合はtrueを返すこと" do
      user = User.new(email: 'guest@example.com')
      expect(user.guest?).to be_truthy
    end

    it "ゲストユーザーでない場合はfalseを返すこと" do
      user = User.new(email: 'test@example.com')
      expect(user.guest?).to be_falsey
    end
  end

  describe "アイコン" do
    it "アイコンを追加できること" do
      user = User.new(email: "test@example.com", password: "password")
      user.avatar.attach(io: Rails.root.join('spec/fixtures/files/default_avatar.png').open, filename: 'default_avatar.png',
                         content_type: 'image/png')
      expect(user.avatar).to be_attached
    end

    it "アイコンを削除できること" do
      user = User.create(email: "test@example.com", password: "password")
      user.avatar.attach(io: Rails.root.join('spec/fixtures/files/default_avatar.png').open, filename: 'default_avatar.png',
                         content_type: 'image/png')
      user.avatar.purge
      expect(user.avatar.attached?).to be_falsey
    end
  end
end
