require 'rails_helper'
RSpec.describe '質問作成機能', type: :system do
  describe '新規作成機能' do
    context '質問を新規作成した場合' do
      before do 
        visit new_thema_path
      end
      it '質問が1つ登録でき質問が表示される' do
        fill_in 'テーマ名', with: 'TDD'
        fill_in '目的', with: 'テスト'
        fill_in '質問', with: 'テスト1'
        click_on '送信'
        expect(Question.last.question).to eq 'テスト1'
      end
      it 'question欄を3つ作って2個登録可能(DBには2個登録されてる)' do
        fill_in 'テーマ名', with: 'TDD'
        fill_in '目的', with: 'テスト'
        2.times{ click_on '追加' }
        question_all = all('.nested-fields input')
        expect(question_all.length).to eq 3
        question_all[0].set('1')
        question_all[1].set('2')
        click_on '送信'
        expect(Question.all.length).to eq 2
      end
    end
    context '質問を編集した場合' do
      before do
        FactoryBot.create(:question)
        thema_id = Thema.last.id
        visit edit_thema_path(thema_id)
      end
      it '未編集で送信した場合、編集前後が一致している' do
        expect(all('.nested-fields input')[0].value).to eq 'question'
        click_on '送信'
        thema_id = Thema.last.id
        visit edit_thema_path(thema_id)
        expect(all('.nested-fields input')[0].value).to eq 'question'
      end
      it 'question欄を3つ追加して2個登録可能(DBには2個登録されてる)' do
        expect(Question.all.length).to eq 1
        2.times{ click_on '追加' }
        question_all = all('.nested-fields input')
        expect(question_all.length).to eq 3
        question_all[1].set('1')
        click_on '送信'
        expect(Question.all.length).to eq 2
      end
    end
  end
end