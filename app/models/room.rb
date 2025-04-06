class Room < ApplicationRecord
  belongs_to :onsen
  has_many :messages, -> { order(created_at: :asc) }, dependent: :destroy
end
