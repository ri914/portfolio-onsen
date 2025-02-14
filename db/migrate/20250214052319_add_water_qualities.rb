class AddWaterQualities < ActiveRecord::Migration[7.0]
  def up
    WaterQuality.create([{ name: '単純温泉' },
                         { name: '塩化物泉' },    
                         { name: '炭酸水素塩泉' },
                         { name: '硫酸塩泉' },
                         { name: '二酸化炭素泉' },
                         { name: '含鉄泉' },
                         { name: '酸性泉' },
                         { name: '含よう素泉' },
                         { name: '硫黄泉' },
                         { name: '放射能泉' }])
  end

  def down
    WaterQuality.where(name: ['単純温泉','塩化物泉','炭酸水素塩泉', '硫酸塩泉', '二酸化炭素泉', '含鉄泉', '酸性泉', '含よう素泉', '硫黄泉', '放射能泉']).destroy_all
  end
end
