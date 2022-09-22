class Place < ApplicationRecord
  belongs_to :thema
  has_many :large_groups, dependent: :destroy
end
