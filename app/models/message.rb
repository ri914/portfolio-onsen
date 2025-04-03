class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user
  belongs_to :parent_message, class_name: "Message", optional: true
  has_many :replies, -> { order(created_at: :asc) }, class_name: "Message", foreign_key: "parent_message_id", dependent: :destroy
  has_one_attached :image

  attr_accessor :remove_image

  before_validation { image.purge if remove_image == '1' }
  before_create :set_editable_until

  validates :content, presence: true

  private

  def set_editable_until
    self.editable_until = 30.minutes.from_now
  end
end
