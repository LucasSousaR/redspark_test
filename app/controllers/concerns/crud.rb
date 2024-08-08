# basic crud
module Crud
  extend ActiveSupport::Concern
  included do
    before_action :set_items, only: [:show, :edit, :update, :destroy, :cancel]
  end

  def index

    @q = model_name.ransack(params[:q])
    @items = @q.result(distinct: true).accessible_by(current_ability).paginate(per_page: 10, page: params[:page])
    #@items = @q.result(distinct: true).accessible_by(current_ability).paginate(per_page: 10, page: params[:page]).order(id: :desc)
  end

  def new
    @item = model_name.new
    # @item.build_product_setting
    # person_role.build_product_setting
    render_crud
  end

  def edit
    render_crud
  end

  def show
    render_crud
  end

  def create
    @item = model_name.create(items_params)
    respond_with @item, flash_now: false, template: path_render_crud(action_name_label)
  end

  def update
    @item.update(items_params)
    # redirect_to(action: 'edit', id: @item.id)
    # if updated
    #   respond_with @item, location: -> { url_for(action: 'edit', id: @item.id) }
    # else
    respond_with @item, location: -> { url_for(action: 'edit', id: @item.id) }
    # end
  end

  def destroy
    @item.destroy
    respond_with @item
  end

  private

  def set_back_url
    session["#{controller_name}_results".to_sym] = request.fullpath if request.format == 'html' && action_name == 'index'
  end

  def set_items

    @item = model_name.find(params[:id])

  end

  def path_render_crud(action = action_name)

    if  _prefixes[0] != "users"
      "layouts/crud/#{action.to_s}" unless template_exists?(action.to_s, _prefixes, variants: request.variant)
    else
      "layouts/crud/#{action.to_s}"
    end

  end

  def render_crud
    render path_render_crud
  end
end