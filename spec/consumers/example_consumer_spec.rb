require 'rails_helper'

RSpec.describe ExampleConsumer do
  describe '#consume' do
    let(:sample_payload1) { { 'message' => 'foo! bar!' } }
    it 'handles single message' do
      fake_message = double('KafkaMessage', payload: sample_payload1)
      consumer = ExampleConsumer.new
      consumer.define_singleton_method(:messages) { [fake_message] }

      expect { consumer.consume }.to output("#{sample_payload1}\n").to_stdout
    end

    it 'handles nil payloads gracefully' do
      fake_message = double('KafkaMessage', payload: nil)
      consumer = ExampleConsumer.new
      consumer.define_singleton_method(:messages) { [fake_message] }

      expect { consumer.consume }.to output("\n").to_stdout
    end
  end
end
