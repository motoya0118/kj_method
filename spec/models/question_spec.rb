require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'バリテーションのテスト' do
    context 'questionカラム' do
      before do
        FactoryBot.create(:user)
        FactoryBot.create(:thema)
      end
      let!(:question){ build(:question_only,thema_id: Thema.last.id)}
      it '未入力は不可' do
        question.question = ''
        expect(question.valid?).to eq false
      end
      it '61文字以上は不可' do
        question.question = Faker::Lorem.characters(number:61)
        expect(question.valid?).to eq false
      end
      it '60文字以下は可' do
        question.question = Faker::Lorem.characters(number:60)
        expect(question.valid?).to eq true
      end
    end
  end
end