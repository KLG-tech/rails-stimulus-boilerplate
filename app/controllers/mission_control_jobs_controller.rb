# frozen_string_literal: true

class MissionControlJobsController < ApplicationController
  http_basic_authenticate_with(
    name: ENV.fetch("BASIC_AUTH_USERNAME"),
    password: ENV.fetch("BASIC_AUTH_PASSWORD")
  )

  def index
  end
end
