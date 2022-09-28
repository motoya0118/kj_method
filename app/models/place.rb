class Place < ApplicationRecord
  belongs_to :thema
  belongs_to :user
  has_many :large_groups, ->{ order(position: :asc) }, dependent: :destroy
end
