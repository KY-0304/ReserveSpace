RSpec.describe Owner, type: :model do
  describe "associations" do
    let(:owner)  { create(:owner) }
    let!(:space) { create(:space, owner: owner) }

    it "ownerを削除するとspaceも削除される" do
      expect do
        owner.destroy
      end.to change(Owner, :count).by(-1).and change(Space, :count).by(-1)
    end
  end
end
