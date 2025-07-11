# frozen_string_literal: true

class TestJob < ApplicationJob
  queue_as :default

  def perform
    puts ">>> Hello from SolidQueue!"
  end
end
