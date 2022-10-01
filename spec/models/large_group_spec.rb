require 'rails_helper'

RSpec.describe LargeGroup, type: :model do
  before do
    FactoryBot.create(:user)
    FactoryBot.create(:thema)
    FactoryBot.create(:place_thema)
  end
  let!(:large_group){ build(:large_group)}
  describe 'バリテーションのテスト' do
    context 'nameカラム' do
      it '30文字未満は登録可能' do
        large_group.name = Faker::Lorem.characters(number:30)
        expect(large_group.valid?).to eq true
      end
      it '31文字以上は登録不可' do
        large_group.name = Faker::Lorem.characters(number:31)
        expect(large_group.valid?).to eq false
      end
    end
    describe 'scope(sorted)のテスト' do
      it 'position昇順に出力される' do
        FactoryBot.create(:large_group, position:3)
        FactoryBot.create(:large_group, position:2)
        FactoryBot.create(:large_group, position:1)
        expect(LargeGroup.all.pluck(:position)).to eq [5,3,1]
        expect(LargeGroup.sorted.pluck(:position)).to eq [1,3,5]
      end
    end
  end
end
