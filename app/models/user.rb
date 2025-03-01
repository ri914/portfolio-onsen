class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def guest?
    email == 'guest@example.com'
  end

  has_many :onsens, dependent: :destroy
  has_many :saved_onsens, dependent: :destroy
  has_one_attached :avatar
end
