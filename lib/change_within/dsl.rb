module ChangeWithin::Dsl
  def change_within(timeout = 3, interval = 0.1, receiver=nil, message=nil, &block)
    c = RSpec::Matchers::BuiltIn::Change.new(receiver, message, &block)
    c.define_singleton_method(:change_details) do
      @change_details ||= ChangeWithin::TimeoutChangeDetails.new(
        matcher_name,
        timeout,
        interval,
        @receiver,
        @message,
        &@block
      )
    end
    c
  end
end