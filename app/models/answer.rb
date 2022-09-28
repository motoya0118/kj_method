class Answer < ApplicationRecord
  belongs_to :question
  has_many :user_answers
  validates :answer, presence: true, length: { maximum: 30 }
end
