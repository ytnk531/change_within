require 'timeout'
require 'rspec/matchers'
require 'rspec/matchers/built_in/change'

module ChangeWithin
  class TimeoutChangeDetails < RSpec::Matchers::BuiltIn::ChangeDetails
    def initialize(matcher_name, timeout, interval, receiver=nil, message=nil, &block)
      super(matcher_name, receiver, message, &block)
      @timeout = timeout
      @interval = interval
    end

    def perform_change(event_proc)
      @actual_before = evaluate_value_proc
      @before_hash = @actual_before.hash
      yield @actual_before if block_given?

      return false unless Proc === event_proc
      event_proc.call

      evaluate_after
      begin
        Timeout.timeout(@timeout) do
          until changed?
            sleep @interval
            evaluate_after
          end
        end
      rescue Timeout::Error
        # do nothing
      end
      true
    end

    def evaluate_after
      @actual_after = evaluate_value_proc
      @actual_hash = @actual_after.hash
    end
  end
end
