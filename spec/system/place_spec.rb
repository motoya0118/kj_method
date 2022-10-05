require 'rails_helper'
RSpec.describe 'KJ法実施機能', type: :system do
  describe 'KJ法実施機能' do
    context 'KJ法実施画面遷移(作成者以外)' do
      before do
        FactoryBot.create(:user)
        FactoryBot.create(:question_lock_true)
        FactoryBot.create(:question_only, thema_id: Thema.last.id)
        FactoryBot.create(:question_only, thema_id: Thema.last.id)
        question_ids = Question.all.ids
        FactoryBot.create(:answer, question_id: question_ids[0], user_id: User.last.id)
        FactoryBot.create(:answer2, question_id: question_ids[1], user_id: User.last.id)
        FactoryBot.create(:answer3, question_id: question_ids[2], user_id: User.last.id)
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        visit login_path
        find('.twitter_login').click
      end
      it 'KJ法実施選択画面に遷移できない' do
        visit new_place_path(Thema.last.id)
        expect(current_url).to have_content mypage_path
      end
      it 'KJ法実施画面に遷移できない' do
        Place.create(user_id: User.find_by(name: 'motoya').id, thema_id: Thema.last.id)
        FactoryBot.create(:large_group)
        FactoryBot.create(:card)
        visit edit_place_path(Place.last.id)
        expect(current_url).to have_content mypage_path
      end
      it 'public_falseのとき、showに遷移不可' do
        Place.create(user_id: User.find_by(name: 'motoya').id, thema_id: Thema.last.id)
        FactoryBot.create(:large_group)
        FactoryBot.create(:card)
        visit place_path(Place.last.id)
        expect(current_url).to have_content mypage_path
      end
      it 'public_trueのとき、showに遷移可' do
        Place.create(user_id: User.find_by(name: 'motoya').id, thema_id: Thema.last.id, public: true)
        FactoryBot.create(:large_group)
        FactoryBot.create(:card)
        visit place_path(Place.last.id)
        expect(current_url).to have_content place_path(Place.last.id)
      end
      it 'public_trueのとき、sessionなしでもshowに遷移可' do
        Place.create(user_id: User.find_by(name: 'motoya').id, thema_id: Thema.last.id, public: true)
        FactoryBot.create(:large_group)
        FactoryBot.create(:card)
        click_on 'Logout'
        visit place_path(Place.last.id)
        expect(current_url).to have_content place_path(Place.last.id)
      end
    end
    context 'KJ法実施画面遷移(作成者)' do
      before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        visit login_path
        find('.twitter_login').click
        FactoryBot.create(:question_lock_true)
        FactoryBot.create(:question_only, thema_id: Thema.last.id)
        FactoryBot.create(:question_only, thema_id: Thema.last.id)
        question_ids = Question.all.ids
        FactoryBot.create(:answer, question_id: question_ids[0], user_id: User.last.id)
        FactoryBot.create(:answer2, question_id: question_ids[1], user_id: User.last.id)
        FactoryBot.create(:answer3, question_id: question_ids[2], user_id: User.last.id)
      end
      it 'KJ法実施選択画面に遷移できる' do
        visit new_place_path(Thema.last.id)
        expect(current_url).to have_content new_place_path(Thema.last.id)
      end
      it 'KJ法実施画面に遷移できる' do
        Place.create(user_id: User.find_by(name: 'hoge').id, thema_id: Thema.last.id)
        FactoryBot.create(:large_group)
        FactoryBot.create(:card)
        visit edit_place_path(Place.last.id)
        expect(current_url).to have_content edit_place_path(Place.last.id)
      end
    end
    context 'kj法実施_選択画面' do
      before do
        FactoryBot.create(:user)
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        visit login_path
        find('.twitter_login').click
        FactoryBot.create(:question_lock_true)
        FactoryBot.create(:question_only, thema_id: Thema.last.id)
        FactoryBot.create(:question_only, thema_id: Thema.last.id)
        question_ids = Question.all.ids
        FactoryBot.create(:answer, question_id: question_ids[0], user_id: User.last.id)
        FactoryBot.create(:answer2, question_id: question_ids[1], user_id: User.last.id)
        FactoryBot.create(:answer3, question_id: question_ids[2], user_id: User.last.id)
      end
      it '実行ボタンを押すとthema_idに紐づいたquestion.answer全てがCardに登録される' do
        visit new_place_path(Thema.last.id)
        expect(Card.all.length).to eq 0
        click_on '取込'
        expect(Card.all.length).to eq 3
      end
      it '回答したユーザーを選択でき、選択したユーザーのみカード化される' do
        FactoryBot.create(:answer, question_id: Question.first.id, user_id: User.first.id, answer: 'motoya')
        visit new_place_path(Thema.last.id)
        uncheck 'hoge(@fuga)'
        click_on '取込'
        expect(Card.all.length).to eq 1
      end
      it 'カード10件ごとに新しいlargegroup,smallgroupを作成する' do
        21.times {FactoryBot.create(:answer, question_id: Question.first.id, user_id: User.first.id, answer: 'motoya')}
        visit new_place_path(Thema.last.id)
        click_on '取込'
        expect(all('.list').length).to eq 3
      end
    end
    context 'kj法実施画面' , js: true do
      before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        visit login_path
        find('.twitter_login').click
        FactoryBot.create(:question_lock_true)
        FactoryBot.create(:question_only, thema_id: Thema.last.id)
        FactoryBot.create(:question_only, thema_id: Thema.last.id)
        question_ids = Question.all.ids
        FactoryBot.create(:answer, question_id: question_ids[0], user_id: User.last.id)
        FactoryBot.create(:answer2, question_id: question_ids[1], user_id: User.last.id)
        FactoryBot.create(:answer3, question_id: question_ids[2], user_id: User.last.id)
        visit new_place_path(Thema.last.id)
        click_on '取込'
        FactoryBot.create(:large_group, place_id: Place.last.id)    
        FactoryBot.create(:small_group, large_group_id: LargeGroup.last.id)    
        visit edit_place_path(Place.last.id)
      end
      it 'largeが移動可能' do
        expect(all('.list')[1]).to have_content '質問1'
        all('.list')[0].drag_to all('.list')[1]
        sleep(1)
        expect(all('.list')[1]).to have_no_content '質問1'
      end
      it 'smallが移動可能' do
        expect(all('.list')[0]).to have_content 'Small_Test_Group'
        all('.small')[0].drag_to all('.small')[1]
        sleep(1)
        expect(all('.list')[0]).to have_no_content 'Small_Test_Group'
      end
      it 'cardが移動可能' do
        expect(all('.list')[1]).to have_content 'Answer_No_1'
        all('.card')[0].drag_to all('.small')[0]
        sleep(1)
        expect(all('.list')[1]).to have_no_content 'Answer_No_1'
      end
      it 'largeが削除可能' do
        expect(all('.list').length).to eq 2
        all('.list')[0].double_click
        sleep(1)
        expect(all('.list').length).to eq 1
      end
      it 'smallが削除可能' do
        expect(all('.small').length).to eq 2
        all('.small')[0].double_click
        sleep(1)
        expect(all('.small').length).to eq 1
      end
      it 'cardが削除可能' do
        expect(all('.card').length).to eq 3
        all('.card')[0].double_click
        sleep(1)
        expect(all('.card').length).to eq 2
      end
      it 'largeが編集可能' do
        expect(all('.list')[0]).to have_content 'MyString'
        expect(all('.list')[0]).to have_no_content 'Next_Type_Text'
        all('.list')[0].click
        sleep(1)
        all('input')[0].set('Next_Type_Text').send_keys(:tab)
        expect(all('.list')[0]).to have_no_content 'MyString'
        expect(all('.list')[0]).to have_content 'Next_Type_Text'
      end
      it 'smallが編集可能' do
        expect(all('.small')[0]).to have_content 'Small_Test_Group'
        expect(all('.small')[0]).to have_no_content 'Next_Type_Text'
        all('.small')[0].click
        sleep(1)
        all('input')[0].set('Next_Type_Text').send_keys(:tab)
        expect(all('.small')[0]).to have_no_content 'Small_Test_Group'
        expect(all('.small')[0]).to have_content 'Next_Type_Text'
      end
      it 'cardが編集可能' do
        expect(all('.card')[0]).to have_content 'Answer_No_1'
        expect(all('.card')[0]).to have_no_content 'Next_Type_Text'
        all('.card')[0].click
        sleep(1)
        all('input')[0].set('Next_Type_Text').send_keys(:tab)
        expect(all('.card')[0]).to have_no_content 'Answer_No_1'
        expect(all('.card')[0]).to have_content 'Next_Type_Text'
      end
      # it 'largeが追加可能' do #<== D&Dが上手くできない(Qiita質問中)
      #   # target = find('.bigs')
      #   # drop_place = all('.repalce-target')[0]
      #   # el1 = page.driver.browser.find_element(class_name: "bigs")
      #   els = page.driver.browser.find_elements(class_name: "list")
      #   el1 = els[0]
      #   el2 = els[1]
      #   page.driver.browser.action.drag_and_drop(el1, el2).perform
      #   # binding.pry
      #   # sleep(3)
      #   # page.driver.browser.action.move_by(100,300).perform
      #   # page.driver.browser.action.drag_and_drop_by(target.native, 10, 100).perform
      #   # target.drag_to drop_place
      #   sleep(3)
      #   binding.pry
      # end
    end
  end
end