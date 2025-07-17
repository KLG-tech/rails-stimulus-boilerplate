# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CalendarController#index', type: :request do
  let(:user) { create(:user) }

  context 'when not signed in' do
    it 'redirects to the login page' do
      get calendar_index_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when signed in' do
    before { sign_in user }

    context 'when user is authorized' do
      before do
        allow_any_instance_of(CalendarPolicy).to receive(:can_acess_page?).and_return(true)
      end

      it 'responds with 200 OK' do
        get calendar_index_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not authorized' do
      before do
        allow_any_instance_of(CalendarPolicy).to receive(:can_acess_page?).and_return(false)
      end

      it 'redirects with alert' do
        get calendar_index_path
        expect(response).to redirect_to(root_path) # or Root
        expect(flash[:alert]).to eq("You are not authorized to perform this action.")
      end
    end
  end
end
