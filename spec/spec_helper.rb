require 'bundler/setup'
require 'asset_symlink'

RSpec.configure do |config|
  config.mock_with :rspec
end

RSpec::Matchers.define :be_a_symlink_to do |y|
  match do |x|
    @symlink_location = File.symlink?(x) && File.readlink(x)

    @symlink_location == y
  end

  failure_message_for_should do |x|
    if !@symlink_location
      "expected #{x} to be a symlink but it was not"
    else 
      "expected #{x} to be a symlink to #{y} but it was a symlink to #{@symlink_location}"
    end
  end
end
