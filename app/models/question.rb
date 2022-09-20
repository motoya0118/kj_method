class Question < ApplicationRecord
  belongs_to :thema
  validates :question, presence: true, length: { maximum: 60 }
end
