class SmallGroup < ApplicationRecord
  acts_as_list
  belongs_to :large_group
  has_many :cards, ->{ order(position: :asc) },dependent: :destroy_async
  validates :name, length: { maximum: 30 }  
end
