require "rails_helper"
include SessionsHelper

RSpec.describe StoresController, type: :controller do
  let(:user) {FactoryBot.create :user}
  let(:store) {FactoryBot.create :store, user_id: user.id}
  let(:valid_attributes) {FactoryBot.attributes_for :store, user_id: user.id}
  let(:invalid_attributes) {FactoryBot.attributes_for :store, name: ""}

  context "user is admin" do
    before do
      admin = FactoryBot.create :user, role: Settings.role.admin.to_i
      @current_user = admin
      log_in admin
    end

    describe "GET #index" do
      let!(:stores) { FactoryBot.create_list :store, 2, user_id: @current_user.id }

      it "assigns @stores" do
        expect(assigns(:stores)).to eq assigns(:stores)
      end

      it do
        get :index
        expect(response).to render_template "stores/list"
      end
    end

    describe "GET #new" do
      it "assigns @store" do
        expect(assigns(:store)).to eq assigns(:store)
      end

      it do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it do
          expect {
            post :create, params: {store: valid_attributes}
          }.to change(Store, :count).by 1
        end

        it do
          post :create, params: {store: valid_attributes}
          expect(response).to redirect_to stores_path
        end
      end

      context "with invalid params" do
        it do
          post :create, params: {store: invalid_attributes}
          expect(response).to render_template :new
        end
      end
    end

    describe "GET #edit" do
      context "resource exist" do
        it do
          get :edit, params: {id: store}
          expect(response).to render_template :edit
        end
      end

      context "resource not found" do
        it do
          get :edit, params: {id: -1}
          expect(response.status).to eq(404)
        end
      end
    end

    describe "PATCH #update" do
      context "with valid params" do
        it "assigns @store" do
          expect(assigns(:store)).to eq assigns(:store)
        end

        let(:new_attributes) do
          FactoryBot.attributes_for :store, name: "name changed"
        end

        it do
          patch :update, params: {id: store, store: new_attributes}
          store.reload
          expect(store.name).to eq new_attributes[:name]
        end

        it do
          patch :update, params: {id: store, store: new_attributes}
          expect(response).to redirect_to stores_path
        end
      end

      context "with invalid params" do
        it do
          patch :update, params: {id: store, store: invalid_attributes}
          expect(response).to render_template :edit
        end
      end

      context "resource not found" do
        it do
          patch :update, params: {id: -1}
          expect(response.status).to eq(404)
        end
      end
    end

    describe "DELETE #destroy" do
      context "resource exist" do
        it "assigns @store" do
          expect(assigns(:store)).to eq assigns(:store)
        end

        it do
          delete :destroy, params: {id: store}
          expect(flash[:success]).to eq "Deleted!"
        end

        it do
          delete :destroy, params: {id: store}
          expect(response).to redirect_to stores_url
        end
      end

      context "resource not found" do
        it do
          delete :destroy, params: {id: -1}
          expect(response.status).to eq(404)
        end
      end
    end

    describe "POST #lock" do
      context "resource exist" do
        it "assigns @store" do
          expect(assigns(:store)).to eq assigns(:store)
        end

        it do
          patch :lock, params: {id: store}
          store.reload
          expect(store.is_lock).to be_truthy
        end

        it do
          patch :lock, params: {id: store}
          store.reload
          expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
      end

      context "resource not found" do
        it do
          delete :destroy, params: {id: -1}
          expect(response.status).to eq(404)
        end
      end
    end

    describe "POST #unlock" do
      context "resource exist" do
        it "assigns @store" do
          expect(assigns(:store)).to eq assigns(:store)
        end

        it do
          patch :unlock, params: {id: store}
          store.reload
          expect(store.is_lock).to be_falsy
        end

        it do
          patch :lock, params: {id: store}
          expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
      end

      context "resource not found" do
        it do
          delete :destroy, params: {id: -1}
          expect(response.status).to eq(404)
        end
      end
    end
  end

  context "user is manager" do
    before do
      manager = FactoryBot.create :user, role: Settings.role.manager.to_i
      @current_user = manager
      log_in manager
    end

    describe "GET #index" do
      let!(:stores) { FactoryBot.create_list :store, 2, user_id: @current_user.id }

      it "assigns @stores" do
        expect(assigns(:stores)).to eq assigns(:stores)
      end

      it do
        get :index
        expect(response).to render_template "stores/list"
      end
    end

    describe "GET #new" do
      it "assigns @store" do
        expect(assigns(:store)).to eq assigns(:store)
      end

      it do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it do
          expect {
            post :create, params: {store: valid_attributes}
          }.to change(Store, :count).by 1
        end

        it do
          post :create, params: {store: valid_attributes}
          expect(response).to redirect_to stores_path
        end
      end

      context "with invalid params" do
        it do
          post :create, params: {store: invalid_attributes}
          expect(response).to render_template :new
        end
      end
    end

    describe "GET #edit" do
      context "resource exist" do
        it do
          store = FactoryBot.create :store, user_id: @current_user.id
          get :edit, params: {id: store}
          expect(response).to render_template :edit
        end
      end

      context "resource not found" do
        it do
          get :edit, params: {id: -1}
          expect(response).to redirect_to home_admin_url
        end
      end
    end

    describe "PATCH #update" do
      context "with valid params" do
        it "assigns @store" do
          expect(assigns(:store)).to eq assigns(:store)
        end

        let(:new_attributes) do
          FactoryBot.attributes_for :store, name: "name changed"
        end

        it do
          store = FactoryBot.create :store, user_id: @current_user.id
          patch :update, params: {id: store, store: new_attributes}
          store.reload
          expect(store.name).to eq new_attributes[:name]
        end

        it do
          store = FactoryBot.create :store, user_id: @current_user.id
          patch :update, params: {id: store, store: new_attributes}
          expect(response).to redirect_to stores_path
        end
      end

      context "with invalid params" do
        it do
          store = FactoryBot.create :store, user_id: @current_user.id
          patch :update, params: {id: store, store: invalid_attributes}
          expect(response).to render_template :edit
        end
      end

      context "resource not found" do
        it do
          patch :update, params: {id: -1}
          expect(response).to redirect_to home_admin_url
        end
      end
    end

    describe "DELETE #destroy" do
      context "resource exist" do
        it "assigns @store" do
          expect(assigns(:store)).to eq assigns(:store)
        end

        it do
          store = FactoryBot.create :store, user_id: @current_user.id
          expect {
            delete :destroy, params: {id: store}
          }.to change(Store, :count).by -1
        end

        it do
          store = FactoryBot.create :store, user_id: @current_user.id
          delete :destroy, params: {id: store}
          expect(flash[:success]).to eq "Deleted!"
        end

        it do
          store = FactoryBot.create :store, user_id: @current_user.id
          delete :destroy, params: {id: store}
          expect(response).to redirect_to stores_url
        end
      end

      context "resource not found" do
        it do
          delete :destroy, params: {id: -1}
          expect(response).to redirect_to home_admin_url
        end
      end
    end
  end

  context "user is member" do
    before do
      member = FactoryBot.create :user, role: Settings.role.member.to_i
      @current_user = member
      log_in member
    end

    describe "GET #index" do
      it do
        get :index
        expect(response).to redirect_to root_path
      end
    end

    describe "GET #new" do
      it do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it do
          expect {
            post :create, params: {store: valid_attributes}
          }.to change(Store, :count).by 1
        end

        it do
          post :create, params: {store: valid_attributes}
          expect(response).to redirect_to stores_path
        end
      end

      context "with invalid params" do
        it do
          post :create, params: {store: invalid_attributes}
          expect(response).to render_template :new
        end
      end
    end

    describe "GET #edit" do
      context "resource exist" do
        it do
          store = FactoryBot.create :store, user_id: @current_user.id
          get :edit, params: {id: store}
          expect(response).to render_template :edit
        end
      end

      context "resource not found" do
        it do
          get :edit, params: {id: -1}
          expect(response).to redirect_to home_admin_url
        end
      end
    end

    describe "PATCH #update" do
      context "with valid params" do
        let(:new_attributes) do
          FactoryBot.attributes_for :store, name: "name changed"
        end

        it do
          store = FactoryBot.create :store, user_id: @current_user.id
          patch :update, params: {id: store, store: new_attributes}
          store.reload
          expect(store.name).to eq new_attributes[:name]
        end

        it do
          store = FactoryBot.create :store, user_id: @current_user.id
          patch :update, params: {id: store, store: new_attributes}
          expect(response).to redirect_to stores_path
        end
      end

      context "with invalid params" do
        it do
          store = FactoryBot.create :store, user_id: @current_user.id
          patch :update, params: {id: store, store: invalid_attributes}
          expect(response).to render_template :edit
        end
      end

      context "resource not found" do
        it do
          patch :update, params: {id: -1}
          expect(response).to redirect_to home_admin_url
        end
      end
    end

    describe "DELETE #destroy" do
      context "resource exist" do
        it do
          store = FactoryBot.create :store, user_id: @current_user.id
          expect {
            delete :destroy, params: {id: store}
          }.to change(Store, :count).by -1
        end

        it do
          store = FactoryBot.create :store, user_id: @current_user.id
          delete :destroy, params: {id: store}
          expect(response).to redirect_to stores_url
        end
      end

      context "resource not found" do
        it do
          delete :destroy, params: {id: -1}
          expect(response).to redirect_to home_admin_url
        end
      end
    end
  end

  context "user is not a member" do
    describe "GET #index" do
      it do
        get :index
        expect(response).to redirect_to login_path
      end
    end

    describe "GET #new" do
      it do
        get :new
        expect(response).to redirect_to login_path
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it do
          post :create, params: {store: valid_attributes}
          expect(response).to redirect_to login_path
        end
      end

      context "with invalid params" do
        it do
          post :create, params: {store: invalid_attributes}
          expect(response).to redirect_to login_path
        end
      end
    end

    describe "GET #edit" do
      context "resource exist" do
        it do
          get :edit, params: {id: store}
          expect(response).to redirect_to login_url
        end
      end

      context "resource not found" do
        it do
          get :edit, params: {id: -1}
          expect(response).to redirect_to login_path
        end
      end
    end

    describe "PATCH #update" do
      context "with valid params" do
        let(:new_attributes) do
          FactoryBot.attributes_for :store, name: "name changed"
        end

        it do
          patch :update, params: {id: store, store: new_attributes}
          expect(response).to redirect_to login_url
        end
      end

      context "with invalid params" do
        it do
          patch :update, params: {id: store, store: invalid_attributes}
          expect(response).to redirect_to login_url
        end
      end

      context "resource not found" do
        it do
          patch :update, params: {id: -1}
          expect(response).to redirect_to login_url
        end
      end
    end

    describe "DELETE #destroy" do
      context "resource exist" do
        it do
          delete :destroy, params: {id: store}
          expect(response).to redirect_to login_url
        end
      end

      context "resource not found" do
        it do
          delete :destroy, params: {id: -1}
          expect(response).to redirect_to login_url
        end
      end
    end
  end
end
