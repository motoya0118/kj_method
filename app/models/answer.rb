class Answer < ApplicationRecord
  belongs_to :question
  validates :answer, presence: true, length: { maximum: 30 }
end
