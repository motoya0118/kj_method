require 'rails_helper'
RSpec.describe '質問・回答機能', type: :system do
  describe '質問・回答機能' do
    context 'thema遷移確認(session無し)' do
      it 'thema_newに遷移不可' do
        visit new_thema_path
        expect(current_url).to have_content login_path
      end
    end
    context 'thema遷移確認(作成者以外)' do
      before do
        FactoryBot.create(:user)
        FactoryBot.create(:question)
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        visit login_path
        find('.twitter_login').click
      end
      it 'themaメインページに遷移不可' do
        visit thema_path(Thema.last.id)
        expect(current_url).to have_content mypage_path
      end
      it 'thema編集に遷移不可' do
        visit edit_thema_path(Thema.last.id)
        expect(current_url).to have_content mypage_path
      end
      it '回答URL発行に遷移不可' do
        visit confirm_thema_path(Thema.last.id)
        expect(current_url).to have_content mypage_path
      end
      it '回答一覧に遷移不可' do
        thema = Thema.last
        thema.update(lock: true)
        visit answers_path(Thema.last.id)
        expect(current_url).to have_content mypage_path
      end
      it 'テーマを削除不可' do
        thema = Thema.last
        thema.update(lock: true)
        delete thema_path(Thema.last.id)
        expect(Thema.all.length).to eq 1
      end
    end
    context 'thema遷移確認(作成者)' do
      before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        visit login_path
        find('.twitter_login').click
        FactoryBot.create(:question)
      end
      it 'themaメインページに遷移可' do
        visit thema_path(Thema.last.id)
        expect(current_url).to have_content thema_path(Thema.last.id)
      end
      it 'thema編集に遷移可' do
        visit edit_thema_path(Thema.last.id)
        expect(current_url).to have_content edit_thema_path(Thema.last.id)
      end
      it '回答URL発行に遷移可' do
        visit confirm_thema_path(Thema.last.id)
        expect(current_url).to have_content confirm_thema_path(Thema.last.id)
      end
      it '回答一覧に遷移可' do
        thema = Thema.last
        thema.update(lock: true)
        visit answers_path(Thema.last.id)
        expect(current_url).to have_content answers_path(Thema.last.id)
      end
      it 'themaを削除可能' do
        thema = Thema.last
        thema.update(lock: true)
        visit thema_path(Thema.last.id)
        click_on 'テーマを削除'
        expect(Thema.all.length).to eq 0
      end
    end
    context '質問を新規作成した場合' do
      before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        visit login_path
        find('.twitter_login').click
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
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        visit login_path
        find('.twitter_login').click
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
    context '回答ページ(session無し)' do
      before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        FactoryBot.create(:user)
        FactoryBot.create(:question)
      end
      it 'sessionがない場合、アクセス不可(ログインページへ遷移)' do
        thema = Thema.last
        thema.update(lock: true)
        visit new_answer_path(thema.id)
        expect(current_url).to have_content login_path
      end
      it 'sessionなしでアクセス=>ログイン=>回答ページに遷移する' do
        thema = Thema.last
        thema.update(lock: true)
        visit new_answer_path(thema.id)
        find('.twitter_login').click
        expect(current_url).to have_content "/answers/new"
      end
    end
    context '回答ページ(session有)' do
      before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        visit login_path
        find('.twitter_login').click
        FactoryBot.create(:question)
      end
      it 'thema_lockがfalseの場合,thema・questionの情報が編集不可になる' do
        thema = Thema.last
        visit edit_thema_path(thema.id)
        expect(current_url).to have_content "themas/#{thema.id}/edit"
        thema.update(lock: true)
        visit edit_thema_path(thema.id)
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
      it '回答ページで1つの質問に1つの回答した時、sessionを持つuser_idがDB上に登録される' do
        thema = Thema.last
        thema.update(lock: true)
        visit new_answer_path(thema.id)
        all('.nested-fields input')[0].set('answer1')
        click_on '送信'
        expect(Answer.last.user_id).to eq User.find_by(name: 'hoge').id
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
    context '回答一覧_1人回答' do
      before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        visit login_path
        find('.twitter_login').click
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
        expect(tables[0]).to have_content "hoge(@fuga)"
        expect(tables[1]).to have_content "Answer_No_2"
        expect(tables[1]).to have_content "hoge(@fuga)"
        expect(tables[2]).to have_content "Answer_No_3"
        expect(tables[2]).to have_content "hoge(@fuga)"
      end
    end
    context '回答一覧_2人回答' do
      before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        visit login_path
        find('.twitter_login').click
        FactoryBot.create(:question_lock_true)
        FactoryBot.create(:question_only, thema_id: Thema.last.id)
        FactoryBot.create(:question_only, thema_id: Thema.last.id)
        FactoryBot.create(:answer, question_id: Question.first.id)
        FactoryBot.create(:user)
        FactoryBot.create(:answer, question_id: Question.first.id, answer: 'motoya_answer')
      end
      it '正しく表示される' do
        visit answers_path(Thema.last.id)
        trs = all('tr')
        expect(trs[1]).to have_content "hoge(@fuga)"
        expect(trs[1]).to have_content "Answer_No_1"
        expect(trs[2]).to have_content "motoya(@puchanpig)"
        expect(trs[2]).to have_content "motoya_answer"
      end
      it 'テーマ一覧から回答ユーザーを選択すると回答ユーザーの回答のみ表示される' do
        visit thema_path(Thema.last.id)
        click_on "hoge(@fuga)"
        tables = all('table')
        expect(tables[0]).to have_content "hoge(@fuga)"
        expect(tables[0]).to have_no_content "motoya(@puchanpig)"
      end
      it '一覧で検索すると全件が、ユーザーを選択すると選択したユーザーのみ検索可能' do
        visit answers_path(Thema.last.id)
        select "hoge(@fuga)"
        click_on "検索"
        tables = all('table')
        expect(tables[0]).to have_content "hoge(@fuga)"
        expect(tables[0]).to have_no_content "motoya(@puchanpig)"
        select "全件"
        click_on "検索"
        tables = all('table')
        expect(tables[0]).to have_content "hoge(@fuga)"
        expect(tables[0]).to have_content "motoya(@puchanpig)"
      end
    end
    context '回答用URL確認画面' do
      before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        visit login_path
        find('.twitter_login').click
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
  describe 'themaメインページ' do
    before do
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      visit login_path
      find('.twitter_login').click
      FactoryBot.create(:question_lock_false)
      FactoryBot.create(:question_only, thema_id: Thema.last.id)
      FactoryBot.create(:question_only, thema_id: Thema.last.id)
      question_ids = Question.all.ids
      FactoryBot.create(:answer, question_id: question_ids[0])
      FactoryBot.create(:answer2, question_id: question_ids[1])
      FactoryBot.create(:answer3, question_id: question_ids[2])
    end
    context 'lockがfalseの場合' do
      before do
        visit thema_path(Thema.last)
      end
      it '(テーマ・質問編集画面)へリンクが存在するo' do
        click_on 'テーマ・質問編集画面'
        expect(current_url).to have_content "/themas/#{Thema.last.id}/edit"
      end
      it '(回答URL確認画面)へリンクが存在するo' do
        click_on '回答URL確認画面'
        expect(current_url).to have_content "/themas/#{Thema.last.id}/confirm"
      end
      it '(回答一覧・KJ法実施)へリンクが存在しないx' do
        base_url = current_url
        expect{click_on '回答一覧'}.to raise_error
        expect{click_on 'KJ法実施'}.to raise_error
      end
    end
    context 'lockがtrueかつ、データを取り込んでいない場合(Place.find_by(id:@thema.id)がnil)' do
      before do
        Thema.last.update(lock: true)
        visit thema_path(Thema.last)
      end
      it '(回答URL確認画面)へリンクが存在するo' do
        click_on '回答URL確認画面'
        expect(current_url).to have_content "/themas/#{Thema.last.id}/confirm"
      end
      it '(回答一覧)へリンクが存在するo' do
        click_on '回答一覧'
        expect(current_url).to have_content "/themas/#{Thema.last.id}/answers"
      end
      it '(KJ法実施new)へリンクが存在するo' do
        click_on 'KJ法実施'
        expect(current_url).to have_content "/themas/#{Thema.last.id}/places/new"
      end
      it '(KJ法結果・テーマ・質問編集画面)へリンクが存在しない' do
        expect{click_on 'KJ法結果'}.to raise_error
        expect{click_on 'テーマ・質問編集画面'}.to raise_error
      end
    end
    context 'lockがtrueかつ、データ取込済の場合(Place.find_by(id:@thema.id)がtrue)' do
      before do
        Thema.last.update(lock: true)
        visit new_place_path(Thema.last)
        click_on '取込'
        visit thema_path(Thema.last)
      end
      it '(回答URL確認画面)へリンクが存在するo' do
        click_on '回答URL確認画面'
        expect(current_url).to have_content "/themas/#{Thema.last.id}/confirm"
      end
      it '(回答一覧)へリンクが存在するo' do
        click_on '回答一覧'
        expect(current_url).to have_content "/themas/#{Thema.last.id}/answers"
      end
      it '(KJ法実施edit)へリンクが存在するo' do
        click_on 'KJ法実施'
        expect(current_url).to have_content "/themas/#{Place.find_by(thema_id:Thema.last.id).id}/places/#{Place.find_by(thema_id:Thema.last.id).id}/edit"
      end
      it '(KJ法結果)へリンクが存在するo' do
        click_on 'KJ法結果'
        expect(current_url).to have_content "/themas/#{Place.find_by(thema_id:Thema.last.id).id}/places/#{Place.find_by(thema_id:Thema.last.id).id}"
      end
      it '(テーマ・質問編集画面)へリンクが存在しない' do
        expect{click_on 'テーマ・質問編集画面'}.to raise_error
      end
      it '回答者名が表示されている' do
        expect(find('.answer_person')).to have_content 'hoge(@fuga)'
      end
      it '回答者twitterへのリンク先が正しい' do
        find('#twitter').click
        expect(current_url).to have_content '/fuga'
      end
    end
  end
end