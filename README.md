# ChangeWithin
Expectation with timeout for RSpec's `change`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'change_within'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install change_within

## Usage

```ruby
def changer
  Thread.new do
    sleep 2
    $x = 10
  end
end

it "waits change with `change_within`" do
  $x = 0
  expect { changer }.to change_within(3) { $x }.by(10)
end

it "waits change with `wait`" do
  $x = 0
  expect { changer }.to change { $x }.wait(3).by(10)
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/change_within. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/change_within/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ChangeWithin project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/change_within/blob/master/CODE_OF_CONDUCT.md).
