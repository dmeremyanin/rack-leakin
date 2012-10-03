# Rack::Leakin

Rack middleware that detect and handle memory leaks

## Usage

Add this line to your application's Gemfile:

```ruby
gem 'rack-leakin'
```

Then, if you are using Rails, simply add to initializer:

```ruby
Rails.application.config.middleware.use Rack::Leakin
```

You can set threshold in kilobytes and the handler:

```ruby
Rack::Leakin.threshold = 131072 # default, 128MB
```

For example, it may be useful to send exceptions to Airbrake:

```ruby
Rack::Leakin.handler = lambda do |env, beginning, ending|
  Airbrake.notify \
    :error_message => "Memory leak detected, from #{beginning}KB to #{ending}KB",
    :error_class   => 'MemoryLeak',
    :parameters => {
      :request_uri => env['REQUEST_URI'],
      :method => env['REQUEST_METHOD']
    }
end
```
