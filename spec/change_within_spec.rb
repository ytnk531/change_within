# frozen_string_literal: true
require 'change_within'

RSpec.describe 'ChangeWithin::Base' do
  include ChangeWithin::Dsl

  def changer
    Thread.new do
      sleep 2
      $x = 10
    end
  end

  it "waites change" do
    $x = 0
    expect { changer }.to change_within(3) { $x }.by(10)
  end
end
