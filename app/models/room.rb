class Room < ApplicationRecord
  belongs_to :onsen
  has_many :messages
end
