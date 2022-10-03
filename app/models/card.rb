class Card < ApplicationRecord
  acts_as_list
  belongs_to :small_group
  validates :content, length: { maximum: 40 }  
end
