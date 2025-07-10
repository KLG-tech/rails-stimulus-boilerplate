# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  if Rails.application.config.x.keycloak.enabled
    devise :omniauthable, omniauth_providers: [:keycloak_openid]
  end

  def self.from_omniauth(auth)
    user_basic_info = auth.dig(:extra, :raw_info, :custom_attributes, :roleapp_access, :user_basic_info)

    if user_basic_info.blank?
      Rails.logger.error("User basic info is empty")
      Rails.logger.debug(auth.inspect)

      raise "User basic info not found, please contact Ceberus support"
    end

    employee_id = user_basic_info[:nip]
    name = user_basic_info[:name]
    email = user_basic_info[:email]

    where(provider: auth[:provider], uid: employee_id).first_or_create do |user|
      user.name = name
      user.email = email
      user.password = Devise.friendly_token[0, 20]
    end
  rescue StandardError => e
    Rails.logger.error("Error creating user: #{e.message}")
    Rails.logger.info("Auth: #{auth.inspect}")

    raise e
  end
end
