require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  before_action :authenticate_user!
  respond_to :html

  before_action do
    begin
      authenticate_user!

    rescue Exception => err
      # Tratar a exceção aqui, se necessário
      puts "Erro ao autenticar o usuário: #{err.message}"
    end
    if user_signed_in?
      cookies.signed[:user_id] ||= current_user.id
      cookies.signed[:user_id] = current_user.id if cookies.signed[:user_id] != current_user.id
    end

  end
  def action_name_label
    case action_name
    when 'create'
      'new'
    when 'update'
      'edit'
    else
      action_name
    end
  end

  private
  def current_ability
    "Abilities::Test".constantize.new(current_user)
  end
end
