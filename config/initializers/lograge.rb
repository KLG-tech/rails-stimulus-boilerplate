Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Json.new

  # Optional: Custom fields
  config.lograge.custom_options = lambda do |event|
    {
      time: event.time,
      user_id: event.payload[:user_id],
      host: event.payload[:host]
    }
  end

  # Add request_id to the log tags
  config.log_tags = [:request_id]
end
