class LargeGroup < ApplicationRecord
  belongs_to :place
  has_many :small_groups, dependent: :destroy
  validates :name, length: { maximum: 30 }  
end
