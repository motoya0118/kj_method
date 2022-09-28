class Place < ApplicationRecord
  belongs_to :thema
  has_many :large_groups, ->{ order(position: :asc) }, dependent: :destroy
end
