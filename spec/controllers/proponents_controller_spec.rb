require 'rails_helper'

RSpec.describe ProponentesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:proponente) { create(:proponente) }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: proponente.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    it "creates a new Proponente" do
      expect {
        post :create, params: { proponente: attributes_for(:proponente) }
      }
    end
  end

  describe "PATCH #update" do
    it "updates the requested proponente" do
      patch :update, params: { id: proponente.id, proponente: { nome: "Jane Doe" } }
      proponente.reload
      expect(proponente.nome).to eq("Jane Doe")
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested proponente" do
      expect {
        delete :destroy, params: { id: proponente.id }
      }.to change(Proponente, :count).by(-1)
    end
  end

  describe "GET #calcula_inss" do
    it "calculates the INSS discount" do
      get :calcula_inss, params: { salario: 3000 }
      json = JSON.parse(response.body)
      expect(json['desconto_inss']).to eq(281.62)
    end
  end
end