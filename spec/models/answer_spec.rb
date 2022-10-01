require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'バリデーションのテスト' do
    before do
      FactoryBot.create(:user)
      FactoryBot.create(:question)
    end
    let!(:answer) { build(:answer, question_id: Question.last.id) }
    subject { test_answer.valid? }
    let(:test_answer) { answer }
    context 'answerカラム' do
      it '空欄でないこと' do
        test_answer.answer = ''
        is_expected.to eq false;
      end
      it '30文字入力可能' do
        answer.answer = Faker::Lorem.characters(number:30)
        expect(answer.valid?).to eq true;
      end
      it '31文字入力不可' do
        test_answer.answer = Faker::Lorem.characters(number:31)
        expect(answer.valid?).to eq false;
      end
    end
  end
end
