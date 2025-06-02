require 'rails_helper'

RSpec.describe OnsensHelper, type: :helper do
  describe '泉質のツールチップ' do
    it '「単純温泉」のツールチップが正しく返されること' do
      expect(helper.water_quality_tooltip('単純温泉')).to eq('「家族の湯」高齢者、子供にもやさしい湯 「美肌の湯」')
    end

    it '「二酸化炭素泉」のツールチップが正しく返されること' do
      expect(helper.water_quality_tooltip('二酸化炭素泉')).to eq('「心臓の湯」')
    end

    it '「炭酸水素塩泉」のツールチップが正しく返されること' do
      expect(helper.water_quality_tooltip('炭酸水素塩泉')).to eq('「美肌の湯」「清涼の湯」')
    end

    it '「塩化物泉」のツールチップが正しく返されること' do
      expect(helper.water_quality_tooltip('塩化物泉')).to eq('「温まりの湯」湯冷めしにくい／「傷の湯」塩分の殺菌効果')
    end

    it '「硫酸塩泉」のツールチップが正しく返されること' do
      expect(helper.water_quality_tooltip('硫酸塩泉')).to eq('「傷の湯」「脳卒中の湯」')
    end

    it '「含鉄泉」のツールチップが正しく返されること' do
      expect(helper.water_quality_tooltip('含鉄泉')).to eq('「婦人の湯」貧血、月経障害、更年期障害などに効く')
    end

    it '「含アルミニウム泉」のツールチップが正しく返されること' do
      expect(helper.water_quality_tooltip('含アルミニウム泉')).to eq('「収れんの湯」／炎症・出血に効果')
    end

    it '「含銅－鉄泉」のツールチップが正しく返されること' do
      expect(helper.water_quality_tooltip('含銅－鉄泉')).to eq('「ミネラルの湯」／鉄と銅による強壮作用')
    end

    it '「硫黄泉」のツールチップが正しく返されること' do
      expect(helper.water_quality_tooltip('硫黄泉')).to eq('「生活習慣病の湯」高血糖、動脈硬化、高血圧などに効く')
    end

    it '「酸性泉」のツールチップが正しく返されること' do
      expect(helper.water_quality_tooltip('酸性泉')).to eq('「皮膚病の湯」殺菌効果')
    end

    it '「放射能泉」のツールチップが正しく返されること' do
      expect(helper.water_quality_tooltip('放射能泉')).to eq('「痛風の湯」「万病の湯」')
    end
  end
end
