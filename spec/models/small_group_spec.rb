require 'rails_helper'

RSpec.describe SmallGroup, type: :model do
  describe 'バリテーションのテスト' do
    before do
      FactoryBot.create(:user)
      FactoryBot.create(:thema)
      FactoryBot.create(:place_thema)
      FactoryBot.create(:large_group)
    end
    let!(:small_group){ build(:small_group)}
    context 'nameカラム' do
      it '31文字以上は入力不可' do
        small_group.name = Faker::Lorem.characters(number:31)
        expect(small_group.valid?).to eq false;
      end
      it '30文字以下は入力可' do
        small_group.name = Faker::Lorem.characters(number:30)
        expect(small_group.valid?).to eq true;
      end
    end
  end
end
