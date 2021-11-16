# frozen_string_literal: true

require_relative "change_within/version"
require_relative 'change_within/timeout_change_details'
require_relative 'change_within/dsl'

module ChangeWithin
  class Error < StandardError; end
end

class RSpec::Matchers::BuiltIn::Change
  def wait(timeout = 3, interval = 0.5)
    define_singleton_method(:change_details) do
      @change_details ||= ChangeWithin::TimeoutChangeDetails.new(
        matcher_name,
        timeout,
        interval,
        @receiver,
        @message,
        &@block
      )
    end
    self
  end
end
