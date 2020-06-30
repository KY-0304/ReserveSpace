require 'rails_helper'

RSpec.describe Owner, type: :model do
  let(:owner) { create(:owner) }

  it "事業者名が無いと無効" do
    owner.company_name = nil
    owner.valid?
    expect(owner.errors.full_messages).to include "事業者名を入力してください"
  end

  it "同じ事業者名は無効" do
    other_owner = owner.dup
    other_owner.valid?
    expect(other_owner.errors.full_messages).to include "事業者名はすでに存在します"
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
end
