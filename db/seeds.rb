Owner.create!(email: "hoge@example.com",
              company_name: "四菱地所プロパティマネジメント",
              password: "password",
              password_confirmation: "password")

owner = Owner.first

6.times do
  owner.spaces.create!(name: "四田国際ビル地下１階スペース",
                      description: "JR新宿駅新南口から1分！新宿三丁目駅E6出口から徒歩30秒！
                                    新宿高島屋の目の前で1階にファミリーマートがあって超便利！
                                    24時間いつでも利用可能最大10名ご利用可能な完全個室。
                                    レイアウト変更が可能な可動式のホワイトボード完備コンパクトで清潔なスペースです。",
                      images: [open('./public/images/space.jpg')],
                      postcode: "1080073",
                      prefecture_code: "13",
                      address_city: "港区",
                      address_street: "三田1-1-1",
                      address_building: "四田国際ビル",
                      phone_number: "03-1234-5678",
                      hourly_price: "1000",
                      business_start_time: "09:00",
                      business_end_time: "21:00")
end

User.create!(email: "fuga@example.com",
             name: "山田太郎",
             phone_number: "080-1234-1234",
             gender: :male,
             password: "password",
             password_confirmation: "password")

# 5.times do |n|
#   Owner.create!(email: "test#{n}@example.com",
#                 company_name: "テスト#{n}株式会社",
#                 password: "password",
#                 password_confirmation: "password")
# end
