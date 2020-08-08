# オーナー作成
Owner.create!(email: "hoge@example.com",
              company_name: "Hoge株式会社",
              password: "password",
              password_confirmation: "password")

# スペース作成
owner = Owner.first
description = <<-EOS
JR田町駅三田口から5分！三田駅A3出口から4分！
レイアウト変更が可能な可動式のホワイトボード完備
コンパクトで清潔な会議室です。
EOS
images = [open('./public/images/space1.jpg'), open('./public/images/space2.jpg'), open('./public/images/space3.jpg'), open('./public/images/space4.jpg')]
postcode = 1080073
prefecture_code = 13
city = "港区"
street = "三田1-1-1"
building = "ReserveSpaceビル"
phone_number = "03-1234-5678"
business_start_time = "09:00"
business_end_time = "21:00"


11.times do |i|
  owner.spaces.create!(name: "#{building}#{i + 1}階会議室",
                      description: description,
                      images: images.shuffle,
                      postcode: postcode,
                      prefecture_code: prefecture_code,
                      address_city: city,
                      address_street: street,
                      address_building: "#{building}#{i + 1}階",
                      phone_number: phone_number,
                      hourly_price: (i + 1) * 1000,
                      business_start_time: business_start_time,
                      business_end_time: business_end_time)
end

# ユーザー作成
User.create!(email: "fuga@example.com",
             name: "山田太郎",
             phone_number: "080-1234-1234",
             gender: :male,
             password: "password",
             password_confirmation: "password")
