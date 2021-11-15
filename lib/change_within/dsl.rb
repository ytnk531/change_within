module ChangeWithin::Dsl
  def change_within(timeout = 3, interval = 0.1, &block)
    ChangeWithin::Base.new(timeout, interval, &block)
  end
end