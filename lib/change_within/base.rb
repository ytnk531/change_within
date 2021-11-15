require 'timeout'

module ChangeWithin
  class Base < RSpec::Matchers::BuiltIn::Change
    private

    def initialize(timeout, interval, receiver=nil, message=nil, &block)
      @timeout = timeout
      @interval = interval
      @receiver = receiver
      @message = message
      @block = block
    end

    def change_details
      @change_details ||= TimeoutChangeDetails.new(
        matcher_name,
        @timeout,
        @interval,
        @receiver,
        @message,
        &@block
      )
    end
  end

  class TimeoutChangeDetails < RSpec::Matchers::BuiltIn::ChangeDetails
    def initialize(matcher_name, timeout, interval, receiver=nil, message=nil, &block)
      if receiver && !message
        raise(
          ArgumentError,
          "`change` requires either an object and message " \
              "(`change(obj, :msg)`) or a block (`change { }`). " \
              "You passed an object but no message."
        )
      end

      @matcher_name = matcher_name
      @timeout = timeout
      @interval = interval
      @receiver = receiver
      @message = message
      @value_proc = block
    end

    def perform_change(event_proc)
      @actual_before = evaluate_value_proc
      @before_hash = @actual_before.hash
      yield @actual_before if block_given?

      return false unless Proc === event_proc
      event_proc.call

      @actual_after = evaluate_value_proc
      @actual_hash = @actual_after.hash
      begin
        Timeout.timeout(@timeout) do
          until changed?
            sleep @interval
            @actual_after = evaluate_value_proc
            @actual_hash = @actual_after.hash
          end
        end
      rescue Timeout::Error
      end
      true
    end
  end
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
