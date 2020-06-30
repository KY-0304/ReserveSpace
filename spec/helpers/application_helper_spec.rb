require 'rails_helper'

RSpec.describe "ApplicationHelper", type: :helper do
  describe "full_title" do
    context "page_titleがblankの場合" do
      it "base_titleのみを返す" do
        expect(helper.full_title("")).to eq "iSpace"
        expect(helper.full_title([])).to eq "iSpace"
        expect(helper.full_title({})).to eq "iSpace"
        expect(helper.full_title(nil)).to eq "iSpace"
      end
    end

    context "page_titleが渡された場合" do
      it "page_title - base_titleとして返す" do
        expect(helper.full_title("Test Page")).to eq "Test Page - iSpace"
      end
    end
  end
end
