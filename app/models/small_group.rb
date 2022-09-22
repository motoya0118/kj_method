class SmallGroup < ApplicationRecord
  belongs_to :large_group
  has_many :cards, dependent: :destroy
  validates :name, length: { maximum: 30 }  
end
