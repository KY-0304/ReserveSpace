require 'rails_helper'

RSpec.describe Owner, type: :model do
  let(:owner) { create(:owner) }

  it "事業者名が無いと無効" do
    owner.company_name = nil
    owner.valid?
    expect(owner.errors.full_messages).to include "会社名を入力してください"
  end

  it "同じ事業者名は無効" do
    other_owner = owner.dup
    other_owner.valid?
    expect(other_owner.errors.full_messages).to include "会社名はすでに存在します"
  end

  it "メールアドレスが無いと無効" do
    owner.email = nil
    owner.valid?
    expect(owner.errors.full_messages).to include "メールアドレスを入力してください"
  end

  it "同じメールアドレスは無効" do
    other_owner = owner.dup
    other_owner.valid?
    expect(other_owner.errors.full_messages).to include "メールアドレスはすでに存在します"
  end

  it "パスワードが無いと無効" do
    owner.password = nil
    owner.valid?
    expect(owner.errors.full_messages).to include "パスワードを入力してください"
  end

  it "パスワードが5文字以下だと無効" do
    owner.password = "12345"
    owner.valid?
    expect(owner.errors.full_messages).to include "パスワードは6文字以上で入力してください"
  end

  it "パスワードと確認用パスワードが一致しないと無効" do
    owner.password              = "password"
    owner.password_confirmation = "password_diff"
    owner.valid?
    expect(owner.errors.full_messages).to include "確認用パスワードとパスワードの入力が一致しません"
  end
end
