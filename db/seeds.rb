# オーナー作成
Owner.create!(email: "guest@example.com",
              company_name: "ReserveSpace株式会社",
              password: "password",
              password_confirmation: "password")

# スペース作成
owner = Owner.first
description = <<-EOS
JR田町駅三田口から5分！三田駅A3出口から4分！
レイアウト変更が可能な可動式のホワイトボード完備
コンパクトで清潔な会議室です。
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
]
postcode = 1080073
prefecture_code = 13
city = "港区"
building = "ReserveSpaceビル"
phone_number = "03-1234-5678"
business_start_time = "09:00"
business_end_time = "21:00"


15.times do |i|
  owner.spaces.create!(name: "#{building}#{i + 1}階会議室",
                       description: description,
                       images: images.sample(2),
                       postcode: postcode,
                       prefecture_code: prefecture_code,
                       address_city: city,
                       address_street: "三田1-4-#{rand(1..28)}",
                       address_building: "#{building}#{i + 1}階",
                       phone_number: phone_number,
                       hourly_price: rand(1..10) * 1000,
                       capacity: rand(10..50),
                       business_start_time: business_start_time,
                       business_end_time: business_end_time)
end

# ユーザー作成
User.create!(email: "guest@example.com",
             name: "ゲストユーザー",
             phone_number: "080-1111-1111",
             gender: :male,
             password: "password",
             password_confirmation: "password")

users = []

10.times do |i|
  users << User.new(email: "user_male#{i}@example.com",
                    name: Gimei.unique.male.kanji,
                    phone_number: "080-#{rand(1000..9999)}-#{rand(1000..9999)}",
                    gender: :male,
                    password: "password",
                    password_confirmation: "password")
end

10.times do |i|
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

vg_comments = [
  "とてもキレイで、快適に利用させていただきました。",
  "管理者の方の、案内が丁寧でよかったです。",
  "清掃が行き届いていたので、とてもキレイでした。",
  "駅から近くて便利でした。",
]

space_ids.sample(rand(1..space_ids.size)).each do |s_id|
  user_ids.sample(rand(1..user_ids.size)).each do |u_id|
    vg_comments.sample(rand(1..vg_comments.size)).each do |c|
      reviews << Review.new(space_id: s_id,
                            user_id: u_id,
                            rate: :very_good,
                            comment: c)
    end
  end
end

g_comments = [
  "いい感じに集中できました。",
  "特に問題なかったので、次も利用したいと思います。",
  "コンビニが近いのがよかったです。",
  "案内が丁寧で、印象がよかったです。",
]

space_ids.sample(rand(1..space_ids.size)).each do |s_id|
  user_ids.sample(rand(1..user_ids.size)).each do |u_id|
    g_comments.sample(rand(1..g_comments.size)).each do |c|
      reviews << Review.new(space_id: s_id,
                            user_id: u_id,
                            rate: :good,
                            comment: c)
    end
  end
end

n_comments = [
  "まあ、普通でした。",
  "良くも悪くも普通でした。利用するのに不便では無いです。",
  "机が汚れていたので少し気になったが、特に他は気にならなかったです。",
  "案内に待たされたのが気になりましたが、部屋自体はよかったです。",
]

space_ids.sample(rand(1..space_ids.size)).each do |s_id|
  user_ids.sample(rand(1..user_ids.size)).each do |u_id|
    n_comments.sample(rand(1..n_comments.size)).each do |c|
      reviews << Review.new(space_id: s_id,
                            user_id: u_id,
                            rate: :normal,
                            comment: c)
    end
  end
end

b_comments = [
  "うーん・・・写真と少し違う部分があるように思えました。",
  "途中でマイクの充電が切れたので、困りました。",
  "金額の割には、そこまでいい会議室ではなかったです。次は無いと思います。",
  "案内が不親切だったので、打ち合わせ前に気分が下がりました。",
]

space_ids.sample(rand(1..space_ids.size)).each do |s_id|
  user_ids.sample(rand(1..user_ids.size)).each do |u_id|
    b_comments.sample(rand(1..b_comments.size)).each do |c|
      reviews << Review.new(space_id: s_id,
                            user_id: u_id,
                            rate: :bad,
                            comment: c)
    end
  end
end

vb_comments = [
  "全く、写真と違います。詐欺かと思いました。",
  "設備の手入れがされてない。プロジェクターが動かなくて焦った。管理人を呼んでもすぐこなくて最悪でした。",
  "この内容でこの金額かよって思いました。",
  "案内する人が新人だったのかわからないが、何聞いても確認しますで待たされた。",
]

space_ids.sample(rand(1..space_ids.size)).each do |s_id|
  user_ids.sample(rand(1..user_ids.size)).each do |u_id|
    vb_comments.sample(rand(1..vb_comments.size)).each do |c|
      reviews << Review.new(space_id: s_id,
                            user_id: u_id,
                            rate: :very_bad,
                            comment: c)
    end
  end
end

Review.import(reviews, validate: false)

# 予約作成
reservations = []

space_ids = Space.ids.sample(5)
now = Time.current
year = now.year
month = now.month
unique_rand_day = (1..27).to_a.shuffle

space_ids.each do |s_id|
  user_ids.sample(rand(1..user_ids.size)).each_with_index do |u_id, i|
    reservations << Reservation.new(space_id: s_id,
                                    user_id: u_id,
                                    start_time: Time.zone.local(year, month, unique_rand_day[i], 9),
                                    end_time: Time.zone.local(year, month, unique_rand_day[i], 11),)
  end
end

unique_rand_day.shuffle!

space_ids.each do |s_id|
  user_ids.sample(rand(1..20)).each_with_index do |u_id, i|
    reservations << Reservation.new(space_id: s_id,
                                    user_id: u_id,
                                    start_time: Time.zone.local(year, month, unique_rand_day[i], 14),
                                    end_time: Time.zone.local(year, month, unique_rand_day[i], 17),)
  end
end

Reservation.import(reservations, validate: false)
