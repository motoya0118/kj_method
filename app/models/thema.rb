class Thema < ApplicationRecord
  validates :name, presence: true, length: { maximum: 60 }
  validates :purpose, length: { maximum: 255 }
  has_many :questions, dependent: :destroy
  has_many :answers, through: :questions
  has_many :places, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :questions, allow_destroy: true , reject_if: lambda {|attributes| attributes['question'].blank?}

  def answer_user_ids
    answers.pluck(:user_id).uniq
  end
end
