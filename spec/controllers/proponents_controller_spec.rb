require 'rails_helper'

RSpec.describe ProponentsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:proponent) { create(:proponent) }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: proponent.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    it "creates a new Proponente" do
      expect {
        post :create, params: { proponent: attributes_for(:proponent) }
      }
    end
  end

  describe "PATCH #update" do
    it "updates the requested proponente" do
      patch :update, params: { id: proponent.id, proponent: { name: "Jane Doe" } }
      proponent.reload
      expect(proponent.name).to eq("Jane Doe")
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested proponente" do
      expect {
        delete :destroy, params: { id: proponent.id }
      }.to change(Proponent, :count).by(-1)
    end
  end

  describe "GET #calculate_inss" do
    it "calculates the INSS discount" do
      get :calculate_inss, params: { wage: 3000 }
      json = JSON.parse(response.body)
      expect(json['discount_inss']).to eq(281.62)
    end
  end
end