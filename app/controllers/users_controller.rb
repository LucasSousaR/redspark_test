class UsersController < ApplicationController
  include ApplicationHelper
  include Crud
  include EnumsHelper
  require "base64"
  before_action :set_items, only: [:show, :edit, :update, :destroy, :cancel, :block, :unblock, ]
  skip_load_and_authorize_resource
  skip_before_action :verify_authenticity_token
  #protect_from_forgery with: :null_session
  respond_to :json, :html

  #layout 'pages'

  def numeric?(lookAhead)
    lookAhead =~ /[[:digit:]]/
  end

  def letter?(lookAhead)
    lookAhead =~ /[[:alpha:]]/
  end

  def index

    params_index = params.permit!
    params_to_search = params_index[:q] || {}
    status = params_to_search['date_select_order_status']
    if status == 'locked_at_unlock'
      to_search = {
        name_or_email_cont: params_to_search['name_or_email_cont'],
        role_id_eq: params_to_search['role_id_eq'] == "Função" ? "" :params_to_search['role_id_eq'],
      }
    elsif status == 'locked_at'
      to_search = {
        name_or_email_cont: params_to_search['name_or_email_cont'],
        role_id_eq:params_to_search['role_id_eq'] == "Função" ? "" :params_to_search['role_id_eq'],

      }
    else
      to_search = {
        name_or_email_cont: params_to_search['name_or_email_cont'],
        role_id_eq: params_to_search['role_id_eq'] == "Função" ? "" :params_to_search['role_id_eq'],
      }

    end
    params_to_search  = to_search
    if status == 'locked_at'
      params_to_search['date_select_order_status'] = 'locked_at'
    end
    @rows = params[:page] || 10
    @q = model_name.ransack(params_to_search)
    if status == 'locked_at_unlock'
      @items = @q.result(distinct: true).accessible_by(current_ability).where(locked_at: nil ).page(params[:page]).per_page(@rows).order(id: :desc)
    elsif status == 'locked_at'
      @items = @q.result(distinct: true).accessible_by(current_ability).where("locked_at is not null").page(params[:page]).per_page(@rows).order(id: :desc)
    else
      @items = @q.result(distinct: true).accessible_by(current_ability).page(params[:page]).per_page(@rows).order(id: :desc)
    end


  end
  def update
    if items_params[:password].present? && items_params[:password_confirmation].present?
      @item.update(items_params)
    else
      @item.update_without_password(items_params)
    end
    flash[:notice] = ['Tudo certo!',  'Usuario atualizado com sucesso.']
    respond_with @item, location: -> { url_for(action: 'edit', id: @item.id) }, template: path_render_crud(action_name_label)
  end

  def create

    @item = model_name.create(items_params)

    respond_to do |format|
      if @item.save!(validate: false)
        flash[:notice] = ['Tudo certo!',  'Cadastro criado com sucesso.']

        format.html { redirect_to users_path, notice: "Cadastro criado com sucesso." }
        format.json { render :index, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end





    #respond_with @item, flash_now: false, template: path_render_crud(action_name_label)
  end
  def password
    @item.update(items_params)
    flash[:notice] = ['Tudo certo!',  'Cadastro atualizado com sucesso.']
    respond_with @item, location: -> { url_for(action: 'edit', id: @item.id) }, template: path_render_crud(action_name_label)
  end

  def edit_user
    @item = model_name.find(params[:id])
    @item.avatar = params[:imagem]
    @item.name   = params[:edit_user_name]
    @item.email  = params[:edit_user_email]

    if items_params[:password].present? && items_params[:password_confirmation].present?
      @item.update(items_params)
    else
      @item.update_without_password(items_params)
    end

    respond_to do |format|
      if @item.save!(validate: false)
        flash[:notice] = ['Tudo certo!',  'Cadastro atualizado com sucesso.']
        format.html { redirect_to users_path, notice: "Cadastro atualizado com sucesso." }
        format.json { render :index, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end

  end
  def block
    @item.update(locked_at: DateTime.now)
    respond_with @item
  end

  def unblock
    @item.update(locked_at: nil)
    respond_with @item
  end

  def user_block
    @item = model_name.find(params[:id])
    @item.update(locked_at: DateTime.now)
    respond_to do |format|
      if @item.save!(validate: false)

        format.html { redirect_to users_path, notice: "Usuário bloqueado com sucesso." }
        format.json { render :index, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end

  end
  def user_unblock
    @item = model_name.find(params[:id])
    @item.update(locked_at: nil)
    respond_to do |format|
      if @item.save!(validate: false)

        format.html { redirect_to users_path, notice: "Usuário desbloqueado criado com sucesso" }
        format.json { render :index, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end


  def recover_email_password

    params['recover_email']

  end
  private
  def set_items
    @item = model_name.find(params[:id])
  end
  def model_name
    User
  end

  def items_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :role_id,
      company_ids: []

    )
  end
end
