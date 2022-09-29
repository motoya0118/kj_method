class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :answer, presence: true, length: { maximum: 30 }
end
