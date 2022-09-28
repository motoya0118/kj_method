class LargeGroup < ApplicationRecord
  acts_as_list
  belongs_to :place
  has_many :small_groups, ->{ order(position: :asc) }, dependent: :destroy
  validates :name, length: { maximum: 30 }  
  scope :sorted, ->{ order(position: :asc) }
end
