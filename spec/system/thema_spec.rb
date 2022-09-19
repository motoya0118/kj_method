require 'rails_helper'
RSpec.describe '質問作成機能', type: :system do
  describe '新規作成機能' do
    context '質問を新規作成した場合' do
      it '質問が1つ登録でき質問が表示される' do
        visit new_thema_path
        fill_in 'テーマ名', with: 'TDD'
        fill_in '目的', with: 'テスト'
        fill_in '質問1', with: 'テスト1'
        click_on '送信'
        binding.pry
        expect(Question.last.question).to eq 'テスト1'
      end
    end
  end
end