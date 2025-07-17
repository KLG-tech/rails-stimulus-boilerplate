# frozen_string_literal: true

class CalendarController < ApplicationController
  before_action :authenticate_user!
  def index
    authorize :calendar, :can_acess_page?
  end
end
