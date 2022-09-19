class Thema < ApplicationRecord
  validates :name, presence: true, length: { maximum: 60 }
  validates :purpose, length: { maximum: 255 }
end
