What is Klaviyo?
----------------

Klaviyo is a real-time service for understanding your customers by aggregating all your customer data, identifying important groups of customers and then taking action.
http://www.klaviyo.com/

What does this Gem do?
----------------------

* Track customers and events directly from your backend.
* Track customers and events via JavaScript using a Rack middleware.

How to install?
---------------

```
gem install klaviyo
```

How to use it with a Rails application?
---------------------------------------

To automatically insert the Klaviyo script in your Rails app, add this to your environment config file or create a new initializer for it:

```ruby
require 'rack/klaviyo'
config.middleware.use "Klaviyo::Client::Middleware", "YOUR_KLAVIYO_API_TOKEN"
```

This will automatically insert the Klaviyo script at the bottom on your HTML page, right before the closing `body` tag.

To record customer actions directly from your backend, in your `application_controller` class add a method to initialize Klaviyo.

```ruby
class ApplicationController < ActionController::Base
  before_filter :initialize_klaviyo

  def initialize_klaviyo
    @klaviyo = Klaviyo::Client.new('YOUR_KLAVIYO_API_TOKEN', 'YOUR_KLAVIYO_PRIVATE_API_TOKEN')
  end
end
```

Then in your controllers where you'd like to record an event:

```ruby
@klaviyo.track('Did something important',
  email: 'john.smith@example.com',
  properties: { key: 'value' }
)
```

To query the Metrics API, call the get_metrics method. Accepts optional page or count keyword arguments.

Example - Requesting the 2nd page of metrics, to return a count of 100:

```ruby
@klaviyo.get_metrics({:page => 1, :count => 100})
```
