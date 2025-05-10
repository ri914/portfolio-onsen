class Room < ApplicationRecord
  belongs_to :onsen, dependent: :destroy
  has_many :messages, -> { order(created_at: :asc) }, dependent: :destroy
end
