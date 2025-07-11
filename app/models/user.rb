# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  if Rails.application.config.x.keycloak.enabled
    devise :omniauthable, omniauth_providers: [:keycloak_openid]
  end

  # Associations
  has_many :user_providers, dependent: :destroy


  # Callbacks
  after_create :assign_default_role

  def self.from_omniauth(auth)
    provider = auth[:provider]

    if respond_to?("from_#{provider}")
      send("from_#{provider}", auth)
    end
  rescue StandardError => e
    Rails.logger.error("Error in from_omniauth: #{e.message}")
    Rails.logger.info("Auth data: #{auth.inspect}")
    raise e
  end

  def self.from_keycloak_openid(auth)
    user_basic_info = auth.dig(:extra, :raw_info, :custom_attributes, :roleapp_access, :user_basic_info)

    raise "User basic info not found in Keycloak response" if user_basic_info.blank?

    email = user_basic_info[:email]
    name = user_basic_info[:name]
    uid  = user_basic_info[:nip]
    provider = auth[:provider]

    raise "Email is required from provider" if email.blank?

    user = find_or_initialize_by(email: email)

    if user.new_record?
      user.name = name.presence || "Unknown"
      user.password = Devise.friendly_token[0, 20]
      user.save!
    end

    user.user_providers.find_or_create_by!(
      provider: provider,
      uid: uid
    )

    user
  end

  # You need to define your function to handle from other provider
  # For ex: def self.from_github(auth)

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end
end
