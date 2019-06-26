require "rails_helper"
include SessionsHelper

RSpec.describe ProductsController, type: :controller do
  let(:user) {FactoryBot.create :user}
  let(:store) {FactoryBot.create :store, user_id: user.id}
  let(:category) {FactoryBot.create :category, store_id: store.id}
  let(:product) {FactoryBot.create :product, category_id: category.id}
  let(:valid_attributes) {FactoryBot.attributes_for :product, category_id: category.id}
  let(:invalid_attributes) {FactoryBot.attributes_for :product, name: ""}

  context "user is admin" do
    before do
      admin = FactoryBot.create :user, role: Settings.role.admin.to_i
      @current_user = admin
      log_in admin
    end

    describe "GET #index" do
      let!(:products) {FactoryBot.create_list :product, 2, category_id: category.id}

      it "assigns @products" do
        expect(assigns(:products)).to eq assigns(:products)
      end

      it do
        get :index
        expect(response).to render_template :index
      end
    end

    describe "GET #new" do
      it "assigns @product" do
        expect(assigns(:product)).to eq assigns(:product)
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
            post :create, params: {product: valid_attributes}
          }.to change(Product, :count).by 1
        end

        it do
          post :create, params: {product: valid_attributes}
          expect(response).to redirect_to products_path
        end
      end

      context "with invalid params" do
        it do
          post :create, params: {product: invalid_attributes}
          expect(response).to render_template :new
        end
      end
    end

    describe "GET #edit" do
      context "resource exist" do
        it do
          get :edit, params: {id: product}
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
      it "assigns @product" do
        expect(assigns(:product)).to eq assigns(:product)
      end

      context "with valid params" do
        let(:new_attributes) do
          FactoryBot.attributes_for :product, name: "name changed"
        end

        it do
          patch :update, params: {id: product, product: new_attributes}
          product.reload
          expect(product.name).to eq new_attributes[:name]
        end

        it do
          patch :update, params: {id: product, product: new_attributes}
          expect(response).to redirect_to products_path
        end
      end

      context "with invalid params" do
        it do
          patch :update, params: {id: product, product: invalid_attributes}
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
        it "assigns @product" do
          expect(assigns(:product)).to eq assigns(:product)
        end

        it do
          get :edit, params: {id: product}
          expect(response).to render_template :edit
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
      let!(:products) {FactoryBot.create_list :product, 2, category_id: category.id}

      it "assigns @products" do
        expect(assigns(:products)).to eq assigns(:products)
      end

      it do
        get :index
        expect(response).to render_template :index
      end
    end

    describe "GET #new" do
      it "assigns @product" do
        expect(assigns(:product)).to eq assigns(:product)
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
            post :create, params: {product: valid_attributes}
          }.to change(Product, :count).by 1
        end

        it do
          post :create, params: {product: valid_attributes}
          expect(response).to redirect_to products_path
        end
      end

      context "with invalid params" do
        it do
          post :create, params: {product: invalid_attributes}
          expect(response).to render_template :new
        end
      end
    end

    describe "GET #edit" do
      context "resource exist" do
        it do
          get :edit, params: {id: product}
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
        it "assigns @product" do
          expect(assigns(:product)).to eq assigns(:product)
        end

        let(:new_attributes) do
          FactoryBot.attributes_for :product, name: "name changed"
        end

        it do
          patch :update, params: {id: product, product: new_attributes}
          product.reload
          expect(product.name).to eq new_attributes[:name]
        end

        it do
          patch :update, params: {id: product, product: new_attributes}
          expect(response).to redirect_to products_path
        end
      end

      context "with invalid params" do
        it do
          patch :update, params: {id: product, product: invalid_attributes}
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
  end

  describe "DELETE #destroy" do
    context "resource exist" do
      it "assigns @product" do
        expect(assigns(:product)).to eq assigns(:product)
      end

      it do
        get :edit, params: {id: product}
        expect(response).to redirect_to login_path
      end
    end

    context "resource not found" do
      it do
        delete :destroy, params: {id: -1}
        expect(response).to redirect_to login_path
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
          post :create, params: {product: valid_attributes}
          expect(response).to redirect_to products_path
        end
      end

      context "with invalid params" do
        it do
          post :create, params: {product: invalid_attributes}
          expect(response).to render_template :new
        end
      end
    end

    describe "GET #edit" do
      context "resource exist" do
        it do
          get :edit, params: {id: product}
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
        let(:new_attributes) do
          FactoryBot.attributes_for :product, name: "name changed"
        end
        it do
          patch :update, params: {id: product, product: new_attributes}
          expect(response).to redirect_to products_path
        end
      end

      context "with invalid params" do
        it do
          patch :update, params: {id: product, product: invalid_attributes}
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
  end

  describe "DELETE #destroy" do
    context "resource exist" do
      it do
        get :edit, params: {id: product}
        expect(response).to redirect_to login_path
      end
    end

    context "resource not found" do
      it do
        delete :destroy, params: {id: -1}
        expect(response).to redirect_to login_path
      end
    end
  end
end
