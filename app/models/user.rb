class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def guest?
    email == 'guest@example.com'
  end

  has_many :onsens, dependent: :destroy
  has_many :saved_onsens, class_name: 'Onsen', foreign_key: 'saved_by_user_id'
  has_one_attached :avatar
end
