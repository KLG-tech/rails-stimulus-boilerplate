# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    sign_out(current_user)
    Rails.logger.info "testsignout"
    if Rails.application.config.x.keycloak.enabled
      query_params = {
        client_id: ENV["KEYCLOAK_CLIENT_ID"],
        client_secret: ENV["KEYCLOAK_CLIENT_SECRET"],
        post_logout_redirect_uri: request.base_url
      }

      redirect_to "#{ENV["KEYCLOAK_URL"]}/realms/#{ENV["KEYCLOAK_REALM"]}/protocol/openid-connect/logout?#{query_params.to_query}", allow_other_host: true
    end
  end

  def login_as
    user = User.find(params[:user_id])
    sign_in(user)

    redirect_to root_path, notice: "Logged in as #{user.name}"
  end
end
