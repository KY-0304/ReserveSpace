RSpec.describe "OwnersRegistrations", type: :request do
  let(:owner) { create(:owner, email: "test_email@example.com", company_name: "test_company") }

  describe "GET #new" do
    it "ステータスコード200を返す" do
      get new_owner_registration_path
      expect(response.status).to eq 200
    end
  end

  describe "POST #create" do
    context "パラメータが妥当な場合" do
      let(:owner_params) { attributes_for(:owner) }

      it "ステータスコード302を返す" do
        post owner_registration_path, params: { owner: owner_params }
        expect(response.status).to eq 302
      end

      it "spaces_pathにリダイレクトする" do
        post owner_registration_path, params: { owner: owner_params }
        expect(response).to redirect_to spaces_path
      end

      it "ownerが登録される" do
        expect do
          post owner_registration_path, params: { owner: owner_params }
        end.to change(Owner, :count).by 1
      end

      it "フラッシュを返す" do
        post owner_registration_path, params: { owner: owner_params }
        expect(flash[:notice]).to eq "ようこそ！ アカウントが登録されました"
      end
    end

    context "パラメータが不正な場合" do
      let(:invalid_owner_params) { attributes_for(:owner, email: "", company_name: "", password: "") }

      it "ステータスコード200を返す" do
        post owner_registration_path, params: { owner: invalid_owner_params }
        expect(response.status).to eq 200
      end

      it "エラー文を返す" do
        post owner_registration_path, params: { owner: invalid_owner_params }
        expect(response.body).to include "以下のエラーが発生しました："
      end

      it "ownerが登録されない" do
        expect do
          post owner_registration_path, params: { owner: invalid_owner_params }
        end.not_to change(Owner, :count)
      end
    end
  end

  describe "GET #edit" do
    context "ログイン済みの場合" do
      before do
        sign_in owner
        get edit_owner_registration_path
      end

      it "ステータスコード200を返す" do
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get edit_owner_registration_path
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_owner_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_owner_session_path
      end
    end
  end

  describe "PUT #update" do
    let(:params) { { email: "hoge@example.com", company_name: "hoge", current_password: "password" } }

    context "ログイン済みの場合" do
      before do
        sign_in owner
        put owner_registration_path, params: { owner: params }
      end

      context "パラメータが妥当な場合" do
        it "ステータスコード302を返す" do
          expect(response.status).to eq 302
        end

        it "root_pathにリダイレクトする" do
          expect(response).to redirect_to root_path
        end

        it "登録情報が更新される" do
          expect(owner.reload.company_name).to eq "hoge"
          expect(owner.reload.email).to eq "hoge@example.com"
        end

        it "フラッシュを返す" do
          expect(flash[:notice]).to eq "アカウントが更新されました"
        end
      end

      context "パラメータが不正な場合" do
        let(:params) { { company_name: "", current_password: "password" } }

        it "ステータスコード200を返す" do
          expect(response.status).to eq 200
        end

        it "エラー文を返す" do
          expect(response.body).to include "以下のエラーが発生しました："
        end

        it "登録情報が更新されない" do
          expect(owner.reload.company_name).to eq "test_company"
        end
      end
    end

    context "ログインしていない場合" do
      before do
        put owner_registration_path, params: { owner: params }
      end

      it "ステータスコード302を返す" do
        expect(response.status).to eq 302
      end

      it "new_owner_session_pathにリダイレクトする" do
        expect(response).to redirect_to new_owner_session_path
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:space) { create(:space, owner: owner) }

    context "ログイン済みの場合" do
      before do
        sign_in owner
      end

      context "現在以降に予約が無いスペースを持っている場合" do
        let!(:reservation) { create(:reservation, :skip_validate, space: space, start_time: Time.current - 2.hours, end_time: Time.current - 1.hour) }

        it "ステータスコード302を返す" do
          delete owner_registration_path
          expect(response.status).to eq 302
        end

        it "root_pathにリダイレクトする" do
          delete owner_registration_path
          expect(response).to redirect_to root_path
        end

        it "掲載者が削除される" do
          expect do
            delete owner_registration_path
          end.to change(Owner, :count).by(-1)
        end

        it "フラッシュを返す" do
          delete owner_registration_path
          expect(flash[:notice]).to eq "ご利用ありがとうございました。アカウントが削除されました。またのご利用をお待ちしています"
        end
      end

      context "現在以降に予約があるスペースを持っている場合" do
        let!(:reservation) { create(:reservation, :skip_validate, space: space, start_time: Time.current + 1.hour, end_time: Time.current + 2.hours) }

        it "ステータスコード302を返す" do
          delete owner_registration_path
          expect(response.status).to eq 302
        end

        it "root_pathにリダイレクトする" do
          delete owner_registration_path
          expect(response).to redirect_to root_path
        end

        it "掲載者が削除されない" do
          expect do
            delete owner_registration_path
          end.not_to change(Owner, :count)
        end

        it "フラッシュを返す" do
          delete owner_registration_path
          expect(flash[:alert]).to eq "未完了の予約があるスペースがある状態では、アカウント削除できません。"
        end
      end
    end

    context "ログインしていない場合" do
      it "ステータスコード302を返す" do
        delete owner_registration_path
        expect(response.status).to eq 302
      end

      it "new_owner_session_pathにリダイレクトする" do
        delete owner_registration_path
        expect(response).to redirect_to new_owner_session_path
      end

      it "掲載者は削除されない" do
        expect do
          delete owner_registration_path
        end.not_to change(Owner, :count)
      end
    end
  end
end
