class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def guest?
    email == 'guest@example.com'
  end

  has_many :onsens, dependent: :destroy
  has_many :saved_onsens, class_name: 'SavedOnsen', foreign_key: 'user_id', dependent: :destroy
  has_one_attached :avatar
end
