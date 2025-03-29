class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user
  has_one_attached :image

  validates :content, presence: true, unless: -> { image.attached? }
  validates :image, presence: true, unless: -> { content.present? }
end
