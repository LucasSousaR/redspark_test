require 'rails_helper'

RSpec.describe RolesController, type: :controller do
  let(:valid_attributes) {
    { name: 'Admin', code: 'admin' }
  }

  let(:invalid_attributes) {
    { name: '', code: '' }
  }

  let(:role) { Role.create! valid_attributes }

  describe "GET #index" do
    context "when user is authorized" do
      it "returns a success response and assigns @items" do
        get :index, params: { q: {} }
        expect(response).to be_successful
        expect(assigns(:items)).to include(role)
      end
    end

    context "when user is not authorized" do
      it "returns a 403 Forbidden response" do
        allow(controller).to receive(:current_ability).and_return(Ability.new(nil)) # Simula um usuário sem permissões
        get :index
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: role.to_param }
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: role.to_param }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Role" do
        expect {
          post :create, params: { role: valid_attributes }
        }.to change(Role, :count).by(1)
      end

      it "redirects to the created role" do
        post :create, params: { role: valid_attributes }
        expect(response).to redirect_to(Role.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e., to display the 'new' template)" do
        post :create, params: { role: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: 'Super Admin' }
      }

      it "updates the requested role" do
        put :update, params: { id: role.to_param, role: new_attributes }
        role.reload
        expect(role.name).to eq('Super Admin')
      end

      it "redirects to the role" do
        put :update, params: { id: role.to_param, role: new_attributes }
        expect(response).to redirect_to(role)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e., to display the 'edit' template)" do
        put :update, params: { id: role.to_param, role: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested role" do
      role = Role.create! valid_attributes
      expect {
        delete :destroy, params: { id: role.to_param }
      }.to change(Role, :count).by(-1)
    end

    it "redirects to the roles list" do
      delete :destroy, params: { id: role.to_param }
      expect(response).to redirect_to(roles_url)
    end
  end
end
