require 'rails_helper'

RSpec.describe Card, type: :model do
  describe 'バリデーションのテスト' do
    context 'contentカラム' do
      before do
        FactoryBot.create(:user)
        FactoryBot.create(:thema)
        FactoryBot.create(:place_thema)
        FactoryBot.create(:large_group)
      end
      let!(:card){ build(:card) }
      it '41文字以上は登録不可' do
        card.content = Faker::Lorem.characters(number:41)
        expect(card.valid?).to eq false;
      end
      it '40文字は登録可' do
        card.content = Faker::Lorem.characters(number:40)
        expect(card.valid?).to eq true;
      end
    end
  end
end
