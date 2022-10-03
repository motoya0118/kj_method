require 'rails_helper'
RSpec.describe 'ユーザーページ', type: :system do
  describe '未ログイン状態' do
    it 'mypageに遷移不可(ログインページに遷移)' do
      visit mypage_path
      expect(current_url).to have_content login_path
    end
    it '削除確認ページに遷移不可(ログインページに遷移)' do
      visit confirm_path
      expect(current_url).to have_content login_path
    end
    #mypage,confirmはcurrent_user専用に設計しているため他のユーザーが特定のユーザーを閲覧・削除することは不可能
  end
  describe 'ログイン状態' do
    before do
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      visit login_path
      find('.twitter_login').click
    end
    it 'mypageに遷移できる' do
      visit mypage_path
      expect(current_url).to have_content mypage_path
    end
    it '削除確認ページに遷移可で、ユーザーを削除できる' do
      visit confirm_path
      expect(User.all.length).to eq 1
      expect(current_url).to have_content confirm_path
      click_on 'YES'
      expect(User.all.length).to eq 0
    end
    
  end
end