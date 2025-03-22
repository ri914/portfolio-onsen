require 'net/http'
require 'json'
require 'uri'

class WeatherService
  def self.fetch_weather_for(prefecture)
    city_name = prefecture_to_city_name(prefecture)

    uri = URI.parse(
      "#{Rails.application.config_for(:weather_api)[:url]}?q=#{city_name},jp" \
      "&appid=#{Rails.application.config_for(:weather_api)[:api_key]}" \
      "&units=metric&lang=ja"
    )

    response = Net::HTTP.get(uri)

    data = JSON.parse(response)

    if data['cod'] == 200
      {
        temperature: data['main']['temp'],
        description: data['weather'][0]['description'],
        icon: data['weather'][0]['icon'],
      }
    else
      nil
    end
  end

  def self.prefecture_to_city_name(prefecture)
    prefecture_map = {
      '北海道' => 'Sapporo',
      '東京都' => 'Tokyo',
      '青森県' => 'Aomori',
      '岩手県' => 'Iwate',
      '宮城県' => 'Sendai',
      '秋田県' => 'Akita',
      '山形県' => 'Yamagata',
      '福島県' => 'Fukushima',
      '茨城県' => 'Ibaraki',
      '栃木県' => 'Tochigi',
      '群馬県' => 'Gunma',
      '埼玉県' => 'Saitama',
      '千葉県' => 'Chiba',
      '神奈川県' => 'Kanagawa',
      '新潟県' => 'Niigata',
      '富山県' => 'Toyama',
      '石川県' => 'Ishikawa',
      '福井県' => 'Fukui',
      '山梨県' => 'Yamanashi',
      '長野県' => 'Nagano',
      '岐阜県' => 'Gifu',
      '静岡県' => 'Shizuoka',
      '愛知県' => 'Aichi',
      '三重県' => 'Mie',
      '滋賀県' => 'Shiga',
      '京都府' => 'Kyoto',
      '大阪府' => 'Osaka',
      '兵庫県' => 'Hyogo',
      '奈良県' => 'Nara',
      '和歌山県' => 'Wakayama',
      '鳥取県' => 'Tottori',
      '島根県' => 'Shimane',
      '岡山県' => 'Okayama',
      '広島県' => 'Hiroshima',
      '山口県' => 'Yamaguchi',
      '徳島県' => 'Tokushima',
      '香川県' => 'Kagawa',
      '愛媛県' => 'Ehime',
      '高知県' => 'Kochi',
      '福岡県' => 'Fukuoka',
      '佐賀県' => 'Saga',
      '長崎県' => 'Nagasaki',
      '熊本県' => 'Kumamoto',
      '大分県' => 'Oita',
      '宮崎県' => 'Miyazaki',
      '鹿児島県' => 'Kagoshima',
      '沖縄県' => 'Okinawa',
    }

    prefecture_map[prefecture] || prefecture
  end
end
