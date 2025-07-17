require 'rails_helper'

RSpec.describe TestJob, type: :job do
  it 'runs perform and outputs to stdout' do
    expect {
      TestJob.new.perform
    }.to output(/Hello from SolidQueue!/).to_stdout
  end
end
