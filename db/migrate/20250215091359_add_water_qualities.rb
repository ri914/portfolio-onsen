class AddWaterQualities < ActiveRecord::Migration[7.1]
  def up
    WaterQuality.create([{ name: '単純温泉' },
                         { name: '二酸化炭素泉' },
                         { name: '炭酸水素塩泉' },
                         { name: '塩化物泉' },
                         { name: '硫酸塩泉' },
                         { name: '含鉄泉' },
                         { name: '含アルミニウム泉' },
                         { name: '含銅－鉄泉' },
                         { name: '硫黄泉' },
                         { name: '酸性泉' },
                         { name: '放射能泉' },
                         { name: 'その他' }])
  end

  def down
    WaterQuality.where(name: ['単純温泉', '二酸化炭素泉', '炭酸水素塩泉', '塩化物泉', '硫酸塩泉', '含鉄泉', '含アルミニウム泉', '含銅－鉄泉', '硫黄泉', '酸性泉', '放射能泉', 'その他']).destroy_all
  end
end
