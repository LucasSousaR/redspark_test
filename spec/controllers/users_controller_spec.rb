require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) {
    { name: 'Test User', email: 'test@example.com', password: 'password', password_confirmation: 'password', role_id: 1 }
  }

  let(:invalid_attributes) {
    { name: '', email: '', password: '', password_confirmation: '' }
  }

  let(:user) { User.create! valid_attributes }

  describe "GET #index" do
    context "when user is authorized" do
      it "returns a success response and assigns @items" do
        get :index, params: { q: {} }
        expect(response).to be_successful
        expect(assigns(:items)).to include(user)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new User" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "redirects to the users list" do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to include('Cadastro criado com sucesso.')
      end
    end

    context "with invalid params" do
      it "renders the new template" do
        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: 'Updated User', email: 'updated@example.com' }
      }

      it "updates the requested user" do
        put :update, params: { id: user.to_param, user: new_attributes }
        user.reload
        expect(user.name).to eq('Updated User')
        expect(user.email).to eq('updated@example.com')
      end

      it "redirects to the edit page with a success message" do
        put :update, params: { id: user.to_param, user: new_attributes }
        expect(response).to redirect_to(action: :edit, id: user.id)
        expect(flash[:notice]).to include('Usuario atualizado com sucesso.')
      end
    end

    context "with invalid params" do
      it "renders the edit template" do
        put :update, params: { id: user.to_param, user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "PUT #block" do
    it "blocks the user" do
      put :block, params: { id: user.to_param }
      user.reload
      expect(user.locked_at).not_to be_nil
    end
  end

  describe "PUT #unblock" do
    it "unblocks the user" do
      put :unblock, params: { id: user.to_param }
      user.reload
      expect(user.locked_at).to be_nil
    end
  end
end
