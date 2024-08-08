# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)


    resource_updated = if account_update_params[:password]
                         update_resource(resource, account_update_params)
                       else
                         resource.update_without_password(account_update_params)
                       end
    yield resource if block_given?
    if resource_updated
      resource.recover = nil
      resource.save!
      options_responder = { location: after_update_path_for(resource), flash_now: false }

      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ? :update_needs_confirmation : :updated
        options_responder[:notice] = find_message(flash_key, options = {})
        # set_flash_message :notice, flash_key
        # redirect_to destroy_user_session_path
      end
      bypass_sign_in resource, scope: resource_name
      respond_with resource, options_responder
      # redirect_to destroy_user_session_path


    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource,  location: edit_user_registration_path(resource.id)
    end
  end

  # DELETE /resource
  # def destroy
  #   if session['organization_tenant']
  #
  #     session['organization_tenant'] = nil
  #     Apartment::Tenant.switch do
  #       super
  #     end
  #   else
  #     super
  #   end
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  protected

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:image, :name, :birthday, :number, :password, :confirm_password, :attribute])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  # def update_resource(resource, params)
  #   resource.update_without_password(params)
  # end
end
