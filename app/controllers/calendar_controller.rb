# frozen_string_literal: true

class CalendarController < ApplicationController
  def index
    authorize :calendar, :can_acess_page?
  end
end
