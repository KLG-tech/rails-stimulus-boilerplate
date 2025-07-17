# spec/requests/home_controller_spec.rb
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HomeController#index', type: :request do
  let(:user) { create(:user) }

  context 'when not signed in' do
    it 'redirects to the login page' do
      get home_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when signed in' do
    before { sign_in user }

    it 'redirects to the dashboard page' do
      get home_path
      expect(response).to redirect_to(dashboard_index_path)
    end
  end
end
