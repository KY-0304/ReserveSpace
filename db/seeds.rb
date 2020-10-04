# オーナー作成
Owner.create!(email: "guest@example.com",
              company_name: "ReserveSpace株式会社",
              password: "password",
              password_confirmation: "password")

# スペース作成
owner = Owner.first
description = <<-EOS
レイアウト変更に便利な可動式ホワイトボード完備。
大きな窓とLED照明で夜でも明るく、清潔感のある貸し会議室です。
レイアウトは自由に変更いただいて構いませんが、お帰りの際には対面形式に戻していただきますようお願いいたします。

〈推奨用途〉
会議、打ち合わせ、商談、セミナー、勉強会、研修会、説明会、面接、教室、自習、読書、ゲーム、着替え、休憩
※お一人での使用も歓迎します

《注意事項》
・室内を含む建物内すべて禁煙です。
・楽器演奏はご遠慮下さい。近隣の方のご迷惑になります。
・飲酒、酒類の持ち込みは一切禁止です。
・飲物はノンアルコールのペットボトル入り飲料のみ持ち込み可能です。ゴミは必ずお持ち帰りください。
・入退室はご予約の時間内に行ってください。予約時間より前の入室や予約時間を過ぎての退室は他の利用者の迷惑となりトラブルになります。
・準備、レイアウト変更、片付け、セルフクリーニングはご予約の時間内にお願いします。その時間も含めて考えた上でご予約ください。
・ゴミは必ずお持ち帰りください。
・お帰りの際にはご予約の時間内でレイアウト（机・椅子の配置）を対面形式に直し、セルフクリーニング（机や床などの清掃）をお願いいたします。
・宅配便など荷物の受取場所としての利用はできません。
EOS

images = [
  open('./public/images/space1.jpg'),
  open('./public/images/space2.jpg'),
  open('./public/images/space3.jpg'),
  open('./public/images/space4.jpg'),
  open('./public/images/space5.jpg'),
  open('./public/images/space6.jpg'),
  open('./public/images/space7.jpg'),
  open('./public/images/space8.jpg'),
  open('./public/images/space9.jpg'),
  open('./public/images/space10.jpg'),
  open('./public/images/space11.jpg'),
  open('./public/images/space12.jpg'),
  open('./public/images/space13.jpg'),
  open('./public/images/space14.jpg'),
  open('./public/images/space15.jpg'),
  open('./public/images/space16.jpg'),
  open('./public/images/space17.jpg'),
  open('./public/images/space18.jpg'),
  open('./public/images/space19.jpg'),
  open('./public/images/space20.jpg'),
]

owner.spaces.create!(name: "フレアイ貸し会議室",
                       description: description,
                       images: images.sample(2),
                       postcode: "160-0023",
                       prefecture_code: 13,
                       address_city: "新宿区",
                       address_street: "西新宿7-10-17",
                       address_building: "新宿ダイカンプラザ",
                       phone_number: "03-#{rand(1000..9999)}-#{rand(1000..9999)}",
                       hourly_price: rand(1..50) * 100,
                       capacity: rand(10..50),
                       business_start_time: "8:00",
                       business_end_time: "20:00")

owner.spaces.create!(name: "1coin会議室東京",
                       description: description,
                       images: images.sample(2),
                       postcode: "103-0028",
                       prefecture_code: 13,
                       address_city: "中央区",
                       address_street: "八重洲2-6-2",
                       address_building: "東京信頼保証協会ビルディング",
                       phone_number: "03-#{rand(1000..9999)}-#{rand(1000..9999)}",
                       hourly_price: rand(1..50) * 100,
                       capacity: rand(10..50),
                       business_start_time: "10:00",
                       business_end_time: "22:00")

owner.spaces.create!(name: "アクア",
                       description: description,
                       images: images.sample(2),
                       postcode: "150-0043",
                       prefecture_code: 13,
                       address_city: "渋谷区",
                       address_street: "道玄坂1-15-3",
                       address_building: "プリメイラ道玄坂",
                       phone_number: "03-#{rand(1000..9999)}-#{rand(1000..9999)}",
                       hourly_price: rand(1..50) * 100,
                       capacity: rand(10..50),
                       business_start_time: "9:00",
                       business_end_time: "18:00")

owner.spaces.create!(name: "コロッセオ南池袋会議室",
                       description: description,
                       images: images.sample(2),
                       postcode: "171-0022",
                       prefecture_code: 13,
                       address_city: "豊島区",
                       address_street: "南池袋3-13-7",
                       address_building: "ホエールビル",
                       phone_number: "03-#{rand(1000..9999)}-#{rand(1000..9999)}",
                       hourly_price: rand(1..50) * 100,
                       capacity: rand(10..50),
                       business_start_time: "9:00",
                       business_end_time: "18:00")

owner.spaces.create!(name: "秋葉原エイト",
                       description: description,
                       images: images.sample(2),
                       postcode: "101-0025",
                       prefecture_code: 13,
                       address_city: "千代田区",
                       address_street: "神田佐久間町3-21-5",
                       address_building: nil,
                       phone_number: "03-#{rand(1000..9999)}-#{rand(1000..9999)}",
                       hourly_price: rand(1..50) * 100,
                       capacity: rand(10..50),
                       business_start_time: "7:00",
                       business_end_time: "17:00")

owner.spaces.create!(name: "BRIKKO STYLE品川会議室",
                       description: description,
                       images: images.sample(2),
                       postcode: "108-0074",
                       prefecture_code: 13,
                       address_city: "港区",
                       address_street: "高輪4-21-20",
                       address_building: nil,
                       phone_number: "03-#{rand(1000..9999)}-#{rand(1000..9999)}",
                       hourly_price: rand(1..50) * 100,
                       capacity: rand(10..50),
                       business_start_time: "0:00",
                       business_end_time: "23:59")

owner.spaces.create!(name: "ワトソン会議室",
                       description: description,
                       images: images.sample(2),
                       postcode: "105-0004",
                       prefecture_code: 13,
                       address_city: "港区",
                       address_street: "新橋2-20-15",
                       address_building: "駅前ビル3号館",
                       phone_number: "03-#{rand(1000..9999)}-#{rand(1000..9999)}",
                       hourly_price: rand(1..50) * 100,
                       capacity: rand(10..50),
                       business_start_time: "0:00",
                       business_end_time: "23:59")

owner.spaces.create!(name: "RAKURAKU上野会議室",
                       description: description,
                       images: images.sample(2),
                       postcode: "110-0005",
                       prefecture_code: 13,
                       address_city: "台東区",
                       address_street: "上野7-3-2",
                       address_building: nil,
                       phone_number: "03-#{rand(1000..9999)}-#{rand(1000..9999)}",
                       hourly_price: rand(1..50) * 100,
                       capacity: rand(10..50),
                       business_start_time: "10:00",
                       business_end_time: "20:00")

owner.spaces.create!(name: "神田よもやま会議室",
                       description: description,
                       images: images.sample(2),
                       postcode: "101-0047",
                       prefecture_code: 13,
                       address_city: "千代田区",
                       address_street: "内神田2-7-2",
                       address_building: nil,
                       phone_number: "03-#{rand(1000..9999)}-#{rand(1000..9999)}",
                       hourly_price: rand(1..50) * 100,
                       capacity: rand(10..50),
                       business_start_time: "9:00",
                       business_end_time: "20:00")

owner.spaces.create!(name: "Let's 目黒",
                       description: description,
                       images: images.sample(2),
                       postcode: "141-0021",
                       prefecture_code: 13,
                       address_city: "品川区",
                       address_street: "上大崎2-11-2",
                       address_building: nil,
                       phone_number: "03-#{rand(1000..9999)}-#{rand(1000..9999)}",
                       hourly_price: rand(1..50) * 100,
                       capacity: rand(10..50),
                       business_start_time: "9:00",
                       business_end_time: "23:00")

owner.spaces.create!(name: "Andalucía MTG",
                       description: description,
                       images: images.sample(2),
                       postcode: "169-0075",
                       prefecture_code: 13,
                       address_city: "新宿区",
                       address_street: "高田馬場1-31-8",
                       address_building: "高田馬場プラザ",
                       phone_number: "03-#{rand(1000..9999)}-#{rand(1000..9999)}",
                       hourly_price: rand(1..50) * 100,
                       capacity: rand(10..50),
                       business_start_time: "10:00",
                       business_end_time: "19:00")

owner.spaces.create!(name: "コンフォートスペース",
                       description: description,
                       images: images.sample(2),
                       postcode: "108-0074",
                       prefecture_code: 13,
                       address_city: "港区",
                       address_street: "高輪4-23-5",
                       address_building: "品川ステージングビル",
                       phone_number: "03-#{rand(1000..9999)}-#{rand(1000..9999)}",
                       hourly_price: rand(1..50) * 100,
                       capacity: rand(10..50),
                       business_start_time: "10:00",
                       business_end_time: "19:00")

owner.spaces.create!(name: "Work Space Tokyo",
                       description: description,
                       images: images.sample(2),
                       postcode: "104-0031",
                       prefecture_code: 13,
                       address_city: "中央区",
                       address_street: "京橋1-6-7",
                       address_building: nil,
                       phone_number: "03-#{rand(1000..9999)}-#{rand(1000..9999)}",
                       hourly_price: rand(1..50) * 100,
                       capacity: rand(10..50),
                       business_start_time: "10:00",
                       business_end_time: "22:00")

owner.spaces.create!(name: "NEXT LEVEL神保町",
                       description: description,
                       images: images.sample(2),
                       postcode: "101-0051",
                       prefecture_code: 13,
                       address_city: "千代田区",
                       address_street: "神田神保町1-62-7",
                       address_building: nil,
                       phone_number: "03-#{rand(1000..9999)}-#{rand(1000..9999)}",
                       hourly_price: rand(1..50) * 100,
                       capacity: rand(10..50),
                       business_start_time: "10:00",
                       business_end_time: "22:00")

owner.spaces.create!(name: "オリンピア会議室",
                       description: description,
                       images: images.sample(2),
                       postcode: "104-0031",
                       prefecture_code: 13,
                       address_city: "中央区",
                       address_street: "京橋3-4-6",
                       address_building: nil,
                       phone_number: "03-#{rand(1000..9999)}-#{rand(1000..9999)}",
                       hourly_price: rand(1..50) * 100,
                       capacity: rand(10..50),
                       business_start_time: "10:00",
                       business_end_time: "22:00")

# ユーザー作成
User.create!(email: "guest@example.com",
             name: "ゲストユーザー",
             phone_number: "080-1111-1111",
             gender: :male,
             password: "password",
             password_confirmation: "password")

users = []

20.times do |i|
  users << User.new(email: "user_male#{i}@example.com",
                    name: Gimei.unique.male.kanji,
                    phone_number: "080-#{rand(1000..9999)}-#{rand(1000..9999)}",
                    gender: :male,
                    password: "password",
                    password_confirmation: "password")
end

20.times do |i|
  users << User.new(email: "user_female#{i}@example.com",
                    name: Gimei.unique.female.kanji,
                    phone_number: "080-#{rand(1000..9999)}-#{rand(1000..9999)}",
                    gender: :female,
                    password: "password",
                    password_confirmation: "password")
end

User.import users

# お気に入り作成
favorites = []

space_ids = Space.ids
user_ids = User.ids

space_ids.each do |s_id|
  user_ids.sample(rand(1..20)).each do |u_id|
    favorites << Favorite.new(space_id: s_id, user_id: u_id)
  end
end

Favorite.import favorites

#　レビュー作成
reviews = []

space_ids = Space.ids
user_ids = User.ids

comments = [
  "とてもキレイで、快適に利用させていただきました。",
  "管理者の方の、案内が丁寧でよかったです。",
  "清掃が行き届いていたので、とてもキレイでした。",
  "駅から近くて便利でした。",
  "いい感じに集中できました。",
  "特に問題なかったので、次も利用したいと思います。",
  "コンビニが近いのがよかったです。",
  "案内が丁寧で、印象がよかったです。",
  "普通でした。",
  "良くも悪くも普通でした。利用するのに不便では無いです。",
  "机が汚れていたので少し気になったが、特に他は気にならなかったです。",
  "案内に待たされたのが気になりましたが、部屋自体はよかったです。",
  "途中でマイクの充電が切れたので、困りました。",
]

rates = [:very_good, :good, :normal]

space_ids.each do |s_id|
  user_ids.sample(rand(21..40)).each do |u_id|
    reviews << Review.new(space_id: s_id,
                          user_id: u_id,
                          rate: rates.sample,
                          comment: comments.sample)
  end
end

Review.import(reviews, validate: false)
