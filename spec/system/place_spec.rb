require 'rails_helper'
RSpec.describe 'KJ法実施機能', type: :system do
  describe 'KJ法実施機能' do
    before do
      FactoryBot.create(:question_lock_true)
      FactoryBot.create(:question_only, thema_id: Thema.last.id)
      FactoryBot.create(:question_only, thema_id: Thema.last.id)
      question_ids = Question.all.ids
      FactoryBot.create(:answer, question_id: question_ids[0])
      FactoryBot.create(:answer2, question_id: question_ids[1])
      FactoryBot.create(:answer3, question_id: question_ids[2])
    end
    context 'kj法実施_選択画面' do
      it '実行ボタンを押すとthema_idに紐づいたquestion.answer全てがCardに登録される' do
        visit new_place_path(Thema.last.id)
        expect(Card.all.length).to eq 0
        click_on '取込'
        expect(Card.all.length).to eq 3
      end
    end
  end
end