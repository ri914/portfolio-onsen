class Onsen < ApplicationRecord
  belongs_to :user
  belongs_to :saved_by_user, class_name: 'User', optional: true

  validates :name, presence: true
end
