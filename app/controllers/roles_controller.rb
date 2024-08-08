class RolesController < ApplicationController
  include ApplicationHelper
  include Crud
  before_action :set_items, only: [:show, :edit, :update, :destroy, :cancel, :block, :unblock]
  skip_load_and_authorize_resource
  respond_to :json, :html
  def index

    @q = model_name.ransack(params[:q])

    @items = @q.result(distinct: true).accessible_by(current_ability).paginate(per_page: 10, page: params[:page]).order(id: :desc)
  end

  private

  def model_name
    Role
  end

  def items_params
    params.require(:role).permit(:name, :code)
  end
end
