require 'rails_helper'

RSpec.describe "ApplicationHelper", type: :helper do
  describe "full_title" do
    context "page_titleがblankの場合" do
      let(:blank_arguments) { ["", [], {}, nil] }

      it "base_titleのみを返す" do
        blank_arguments.each do |blank|
          expect(helper.full_title(blank)).to eq "iSpace"
        end
      end
    end

    context "page_titleが渡された場合" do
      it "page_title - base_titleとして返す" do
        expect(helper.full_title("Test Page")).to eq "Test Page - iSpace"
      end
    end
  end
end
