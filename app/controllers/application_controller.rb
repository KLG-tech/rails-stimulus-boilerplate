# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected
    def configure_permitted_parameters
      # For sign up
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end

  private
    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referer || root_path)
    end
end
