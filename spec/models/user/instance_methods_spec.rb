RSpec.describe User, type: :model do
  describe "instance_methods" do
    describe "favorite?(space)" do
      let(:user)  { create(:user) }
      let(:space) { create(:space) }

      context "利用者がスペースをお気に入りしていた場合" do
        let!(:favorite) { create(:favorite, user: user, space: space) }

        it "trueを返す" do
          expect(user.favorite?(space)).to eq true
        end
      end

      context "利用者がスペースをお気に入りにしていない場合" do
        it "falseを返す" do
          expect(user.favorite?(space)).to eq false
        end
      end
    end
  end
end
