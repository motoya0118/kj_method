class Card < ApplicationRecord
  belongs_to :small_group
  validates :content, length: { maximum: 30 }  
end
