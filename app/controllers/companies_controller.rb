class CompaniesController < ApplicationController
  include Crud
  before_action :set_items, only: [:show, :edit, :update, :destroy, :cancel, :block, :unblock]


  private

  def model_name
    Company
  end

  def items_params
    params.require(:company).permit(
      :name,
      :cnpj
    )
  end
end
