# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def omniauth_provider
      auth = request.env["omniauth.auth"]
      Rails.logger.debug(auth)

      @user = User.from_omniauth(auth)

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
      else
        session["devise.omniauth_data"] = auth
        redirect_to new_user_registration_url
      end
    end

    def failure
      redirect_to root_path(error: "Failed to sign in")
    end

    Devise.omniauth_providers.each do |provider|
      define_method(provider) do
        # This for handling every omniauth provider you have on the application
        omniauth_provider
      end
    end
  end
end
