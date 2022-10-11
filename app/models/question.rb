class Question < ApplicationRecord
  belongs_to :thema
  has_many :answers, dependent: :destroy
  validates :question, presence: true, length: { maximum: 60 }
  accepts_nested_attributes_for :answers, allow_destroy: true , reject_if: lambda {|attributes| attributes['answer'].blank?}
end
