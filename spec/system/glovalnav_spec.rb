require 'rails_helper'
RSpec.describe 'グローバルナナビゲーション', type: :system do
  context '未ログイン状態' do
    before do
      visit top_path
    end
    it 'Top,使い方,sign_up,loginのみ表示される' do
      nav_elemens = all('.nav-link')
      nav_texts = nav_elemens.map { |element| element.text }
      expect(nav_texts).to match_array ["Top","使い方","Sign up","Login"]
    end
    it 'Topのリンク先が正しいこと' do
      click_on 'Top'
      expect(current_url).to have_content top_path
    end
    it '使い方のリンク先が正しいこと' do
      click_on '使い方'
      expect(current_url).to have_content about_path
    end
    it 'sign upのリンク先が正しいこと' do
      click_on 'Sign up'
      expect(current_url).to have_content login_path
    end
    it 'loginのリンク先が正しいこと' do
      click_on 'Login'
      expect(current_url).to have_content login_path
    end
  end
  context 'ログイン状態' do
    before do
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      visit login_path
      click_on 'Twitterでサインアップしてね'
    end
    it 'Top,使い方,マイページ,テーマ作成,Logoutのみ表示される' do
      nav_elemens = all('.nav-link')
      nav_texts = nav_elemens.map { |element| element.text }
      expect(nav_texts).to match_array ["Top","使い方","マイページ","テーマ作成","Logout"]
    end
    it 'マイページのリンク先が正しいこと' do
      click_on 'マイページ'
      expect(current_url).to have_content mypage_path
    end
    it 'テーマ作成のリンク先が正しいこと' do
      click_on 'テーマ作成'
      expect(current_url).to have_content new_thema_path
    end
    it 'Logoutのリンクをクリックするとログアウトできる' do
      click_on 'Logout'
      nav_elemens = all('.nav-link')
      nav_texts = nav_elemens.map { |element| element.text }
      expect(nav_texts).to match_array ["Top","使い方","Sign up","Login"]
    end
  end
  context 'ログイン状態,Admin' do
    before do
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      visit login_path
      click_on 'Twitterでサインアップしてね'
    end
    it 'Adminがfalseのとき遷移不可' do
      Capybara.raise_server_errors = false
      visit rails_admin_path
      expect(page).to have_content 'CanCan::AccessDenied'
    end
    it 'admin_trueのとき、Adminが追加される' do
      user = User.last
      user.update(admin: true)
      visit mypage_path
      nav_elemens = all('.nav-link')
      nav_texts = nav_elemens.map { |element| element.text }
      expect(nav_texts).to match_array ["Top","使い方","マイページ","テーマ作成","Logout","Admin"]
    end
    it 'admin_trueのとき、Adminに遷移可能' do
      user = User.last
      user.update(admin: true)
      visit mypage_path
      click_on 'Admin'
      header = find('header')
      expect(page).not_to have_content 'CanCan::AccessDenied'
      expect(header).to have_content 'サイト管理'
    end

  end
  context 'ログイン状態,かつテーマ1つ作成した直後' do
    before do
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      visit login_path
      click_on 'Twitterでサインアップしてね'
      FactoryBot.create(:thema, name: 'test1')
      FactoryBot.create(:thema,name: 'test2')
    end
    it '作成したテーマページに遷移すると(テーマに戻る)ボタンが追加される' do
      visit thema_path(Thema.last.id)
      nav_elemens = all('.nav-link')
      nav_texts = nav_elemens.map { |element| element.text }
      expect(nav_texts).to match_array ["Top","使い方","マイページ","テーマ作成","Logout","テーマに戻る"]
    end
    it 'テーマtest1に遷移後、テーマに戻るを押すとtest1に遷移する' do
      visit thema_path(Thema.find_by(name: 'test1').id)
      click_on 'テーマに戻る'
      expect(current_url).to have_content thema_path(Thema.find_by(name: 'test1').id)
    end
    it 'テーマtest1に遷移 => テーマ2に遷移 => テーマに戻るを押すとtest2に遷移する' do
      visit thema_path(Thema.find_by(name: 'test1').id)
      visit thema_path(Thema.find_by(name: 'test2').id)
      click_on 'テーマに戻る'
      expect(current_url).to have_content thema_path(Thema.find_by(name: 'test2').id)
    end
  end
end