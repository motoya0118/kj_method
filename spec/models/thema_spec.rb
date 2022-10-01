require 'rails_helper'

RSpec.describe Thema, type: :model do
  describe 'バリデーションのテスト' do
    before do
      FactoryBot.create(:user)
    end
    let!(:thema){ build(:thema)}
    context 'nameカラム' do
      it '未入力は不可' do
        thema.name = ''
        expect(thema.valid?).to eq false
      end
      it '61文字以上は不可' do
        thema.name = Faker::Lorem.characters(number:61)
        expect(thema.valid?).to eq false
      end
      it '60文字以下は可' do
        thema.name = Faker::Lorem.characters(number:60)
        expect(thema.valid?).to eq true
      end
    end
    context 'purposeカラム' do
      it '256文字以上は不可' do
        thema.purpose = Faker::Lorem.characters(number:256)
        expect(thema.valid?).to eq false
      end
      it '255文字以下は可' do
        thema.purpose = Faker::Lorem.characters(number:255)
        expect(thema.valid?).to eq true
      end
    end
  end
  describe 'インスタンスmethodのテスト' do
    context 'answer_user_ids' do
      it '紐づいているanswer.user_idのユニーク値を配列で返却する' do
        ct = 0
        5.times do
          FactoryBot.create(:user,email: Faker::Internet.email)
          if ct == 0
            FactoryBot.create(:question)
            ct += 1
          end
          FactoryBot.create(:answer,question_id:Question.last.id)
          FactoryBot.create(:answer2,question_id:Question.last.id)
          FactoryBot.create(:answer3,question_id:Question.last.id)
        end
        thema = Thema.last
        user_ids = []
        thema.answers.each do |answer|
          user_ids << answer.user_id
        end
        expect(thema.answer_user_ids).to match_array user_ids.uniq!
      end
    end
  end
end