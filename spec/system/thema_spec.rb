require 'rails_helper'
RSpec.describe '質問・回答機能', type: :system do
  describe '質問・回答機能' do
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
        expect(all('.nested-fields input')[0].value).to eq 'question1'
        click_on '送信'
        thema_id = Thema.last.id
        visit edit_thema_path(thema_id)
        expect(all('.nested-fields input')[0].value).to eq 'question1'
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
    context '回答ページ' do
      before do
        FactoryBot.create(:question)
      end
      it 'thema_lockがfalseの場合,thema・questionの情報が編集不可になる' do
        thema = Thema.last
        visit edit_thema_path(thema.id)
        expect(current_url).to have_content "themas/#{thema.id}/edit"
        thema.update(lock: true)
        visit edit_thema_path(thema.id)
        binding.pry
        expect(current_url).to have_no_content "themas/#{thema.id}/edit"
      end
      it 'thema_lockがfalseの場合、thema#showにリダイレクトされる' do
        thema = Thema.last
        expect(thema.lock).to eq(false)
        visit new_answer_path(thema.id)
        expect(current_url).to have_no_content "/answers/new"
      end
      it '回答ページで1つの質問に1つの回答ができる' do
        thema = Thema.last
        thema.update(lock: true)
        visit new_answer_path(thema.id)
        all('.nested-fields input')[0].set('answer1')
        click_on '送信'
        expect(Answer.last.answer).to eq 'answer1'
      end
      it '回答ページで3つの質問に、回答欄を2つ追加して2つ回答できる' do
        thema = Thema.last
        thema.update(lock: true)
        2.times{FactoryBot.create(:question_lock_true, thema_id: thema.id)}
        visit new_answer_path(thema.id)
        3.times do
          expect(current_url).to have_content "new"
          2.times{ click_on '追加' }
          question_all = all('.nested-fields input')
          question_all[0].set('0')
          question_all[1].set('1')
          click_on '送信'
        end
        expect(current_url).to have_no_content "/answers/new"
        expect(Answer.all.length).to eq 6
        expect(Question.last.answers.length).to eq 2
      end
    end
    context '回答一覧' do
      before do
        FactoryBot.create(:question_lock_true)
        FactoryBot.create(:question_only, thema_id: Thema.last.id)
        FactoryBot.create(:question_only, thema_id: Thema.last.id)
      end
      it '3つの質問に対して1つづつ回答した結果が全て反映されている' do
        question_ids = Question.all.ids
        FactoryBot.create(:answer, question_id: question_ids[0])
        FactoryBot.create(:answer2, question_id: question_ids[1])
        FactoryBot.create(:answer3, question_id: question_ids[2])
        visit answers_path(Thema.last.id)
        tables = all('table')
        expect(tables[0]).to have_content "Answer_No_1"
        expect(tables[1]).to have_content "Answer_No_2"
        expect(tables[2]).to have_content "Answer_No_3"
      end
    end
    context '回答用URL確認画面' do
      before do
        FactoryBot.create(:question)
        FactoryBot.create(:question_only, thema_id: Thema.last.id, question: 'question2')
        FactoryBot.create(:question_only, thema_id: Thema.last.id, question: 'question3')
        visit confirm_thema_path(Thema.last.id)
      end
      it 'テーマ名、目的、質問が表示されている' do
        expect(page).to have_content "thema_name"
        expect(page).to have_content "thema_purpose"
        expect(page).to have_content "question1"
        expect(page).to have_content "question2"
        expect(page).to have_content "question3"        
      end
      it 'thema_lockがfalseの場合、thema_lockをtrueに変更可能,かつ回答用URLが閲覧可能' do
        expect(Thema.last.lock).to eq false
        expect(page).to have_no_content '回答用URL発行済'
        expect(page).to have_no_content "themas/#{Thema.last.id}/answers/new"
        click_link '回答用URL発行'
        sleep(1)
        expect(Thema.last.lock).to eq true
        expect(page).to have_content '回答用URL発行済'
        expect(page).to have_content "themas/#{Thema.last.id}/answers/new"
      end
    end
    
  end
end