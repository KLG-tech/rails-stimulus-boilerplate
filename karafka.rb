# frozen_string_literal: true

class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka = {
      'bootstrap.servers': ENV['KAFKA_BOOTSTRAP_SERVER']
    }
    config.client_id = "#{ENV.fetch('KAFKA_CLIENT_ID', "rsp_#{ENV['RAILS_ENV']}")}_#{Process.pid}"

    # Fix: Remove duplicate group_id assignment and use the proper one
    config.group_id = ENV.fetch('KAFKA_GROUP_ID', "rsp_#{ENV['RAILS_ENV']}")

    # Recreate consumers with each batch. This will allow Rails code reload to work in the
    # development mode. Otherwise Karafka process would not be aware of code changes
    config.consumer_persistence = !Rails.env.development?
  end

  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  Karafka.monitor.subscribe(
    Karafka::Instrumentation::LoggerListener.new(
      # Karafka, when the logger is set to info, produces logs each time it polls data from an
      # internal messages queue. This can be extensive, so you can turn it off by setting below
      # to false.
      log_polling: true
    )
  )
  # Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)

  # This logger prints the producer development info using the Karafka logger.
  # It is similar to the consumer logger listener but producer oriented.
  Karafka.producer.monitor.subscribe(
    WaterDrop::Instrumentation::LoggerListener.new(
      # Log producer operations using the Karafka logger
      Karafka.logger,
      # If you set this to true, logs will contain each message details
      # Please note, that this can be extensive
      log_messages: false
    )
  )

  routes.draw do
    topic :example do
      consumer ExampleConsumer
    end
  end
end

# Karafka now features a Web UI!
# Visit the setup documentation to get started and enhance your experience.
#
# https://karafka.io/docs/Web-UI-Getting-Started

# Define a lightweight Struct to wrap topic names for the Web UI.
# This is more performant than OpenStruct and resolves the RuboCop warning.
TopicWrapper = Struct.new(:name)

Karafka::Web.setup do |config|
  # Set a unique group_id for the Web UI
  config.group_id = ENV.fetch('KAFKA_WEB_GROUP_ID', "rsp_web_#{ENV['RAILS_ENV']}")

  # You may want to set it per ENV. This value was randomly generated.
  config.ui.sessions.secret = 'd0bc6e84e1f4dc29bbbdb69c3cb903f1d34f6c13aecbce21634550825d997669'

  # Configure Web UI topics with consistent naming
  name_suffix = 'rsp'

  # Use the more performant Struct to wrap the topic names.
  config.topics.errors = TopicWrapper.new("karafka_errors_#{name_suffix}")
  config.topics.consumers.reports = TopicWrapper.new("karafka_consumers_reports_#{name_suffix}")
  config.topics.consumers.states = TopicWrapper.new("karafka_consumers_states_#{name_suffix}")
  config.topics.consumers.metrics = TopicWrapper.new("karafka_consumers_metrics_#{name_suffix}")
  config.topics.consumers.commands = TopicWrapper.new("karafka_consumers_commands_#{name_suffix}")
end

Karafka::Web.enable!
