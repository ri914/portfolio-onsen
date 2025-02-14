class WaterQuality < ApplicationRecord
  has_and_belongs_to_many :onsens
  validates :name, presence: true
end
