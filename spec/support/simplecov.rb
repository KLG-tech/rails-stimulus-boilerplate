
require 'simplecov'
require 'simplecov_lcov_formatter'

SimpleCov::Formatter::LcovFormatter.config do |config|
  config.output_directory = 'coverage/lcov'
  config.lcov_file_name = 'lcov.info'
  config.report_with_single_file = true
end

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::LcovFormatter
])

SimpleCov.start 'rails' do
  add_filter 'app/channels'
  add_filter 'app/views'
  add_filter 'app/helpers'
  add_filter 'app/policies'
  add_filter 'app/mailers'
end
