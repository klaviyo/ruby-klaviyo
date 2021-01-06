What is Klaviyo?
----------------

Klaviyo is a real-time service for understanding your customers by aggregating all your customer data, identifying important groups of customers and then taking action.
http://www.klaviyo.com/

What does this Gem do?
----------------------

* Track customers and events directly from your backend.
* Track customers and events via JavaScript using a Rack middleware.
* Access historical metric data.
* Manage lists and profiles in Klaviyo.

How to install?
---------------

```
gem install klaviyo
```

API Examples
------------

Require the Klaviyo module in the file, and then set your Public and Private API keys:

```ruby
# require the klaviyo module
require 'klaviyo'

# set your 6 digit Public API key
Klaviyo.public_api_key = 'YOUR_PUBLIC_API_KEY'

# set your Private API key
Klaviyo.private_api_key = 'YOUR_PRIVATE_API_KEY'
```

Public:

```ruby
# used to track events
Klaviyo::Public.track(
  'Filled out profile',
  email: 'someone@mailinator.com',
  properties: {
    'Added social accounts' : False,
  }
)

# using a phone number to track events
Klaviyo::Public.track(
  'TestedSMSContact',
  phone_number: '+15555555555',
  properties: {
    'Added social accounts' : False,
  }
)

# used for identifying customers and managing profile properties
Klaviyo::Public.identify(
  email: 'thomas.jefferson@mailinator.com',
  properties: {
    '$first_name': 'Thomas',
    '$last_name': 'Jefferson',
    'Plan': 'Premium'
  }
)
```

Lists:

```ruby
# to add a new list
Klaviyo::Lists.create_list('NEW_LIST_NAME')

# to get all lists
Klaviyo::Lists.get_lists()

# to get list details
Klaviyo::Lists.get_list_details('LIST_ID')

# to update a list name
Klaviyo::Lists.update_list_details('LIST_ID', 'LIST_NAME_UPDATED')

# to delete a list
Klaviyo::Lists.delete_list('LIST_ID')

# to check email address subscription status to a list
Klaviyo::Lists.check_list_subscriptions(
  'LIST_ID',
  emails: ['test1@example.com'],
  phone_numbers: ['5555555555'],
  push_tokens: ['PUSH_TOKEN']
)

# to add subscribers to a list, this will follow the lists double opt in settings
Klaviyo::Lists.add_subscribers_to_list(
  'LIST_ID',
  profiles: [
    {
      email: 'test1@example.com'
    },
    {
      phone_number: '5555555555'
    }
  ]
)

# to unsubscribe and remove profile from a list and suppress a profile
Klaviyo::Lists.unsubscribe_from_list(
  'LIST_ID',
  emails: ['test1@example.com']
)

# to add members to a list, this doesn't care about the list double opt in setting
Klaviyo::Lists.add_to_list(
  'LIST_ID',
  profiles: [
    {
      email: 'test1@example.com'
    },
    {
      email: 'test2@example.com'
    }
  ]
)

# to check email profiles if they're in a list
Klaviyo::Lists.check_list_memberships(
  'LIST_ID',
  emails: ['test1@example.com'],
  phone_numbers: ['5555555555'],
  push_tokens: ['PUSH_TOKEN']
)

# to remove profiles from a list
Klaviyo::Lists.remove_from_list(
  'LIST_ID',
  emails: ['test1@example.com'],
  phone_numbers: ['5555555555'],
  push_tokens: ['PUSH_TOKEN']
)

# to get exclusion emails from a list - marker is used for paginating
Klaviyo::Lists.get_list_exclusions('LIST_ID', marker: 'EXAMPLE_MARKER')

# to get all members in a group or list
Klaviyo::Lists.get_group_members('LIST_ID')
```

Profiles:

```ruby
# get profile by profile_id
Klaviyo::Profiles.get_person_attributes('PROFILE_ID')

# update a profile
Klaviyo::Profiles.update_person_attributes(
  'PROFILE_ID',
  PropertyName1: 'value',
  PropertyName2: 'value'
)

# get all metrics for a profile with the default kwargs
Klaviyo::Profiles.get_person_metrics_timeline(
  'PROFILE_ID',
  since: nil,
  count: 100,
  sort: 'desc'
)

# get all events of a metric for a profile with the default kwargs
Klaviyo::Profiles.get_person_metric_timeline(
  'PROFILE_ID',
  'METRIC_ID',
  since: nil,
  count: 100,
  sort: 'desc'
)
```

Metrics:

```ruby
# get all metrics with the default kwargs
Klaviyo::Metrics.get_metrics(page: 0, count: 100)

# get a batched timeline of all metrics with the default kwargs
Klaviyo::Metrics.get_metrics_timeline(
  since: nil,
  count: 100,
  sort: 'desc'
)

# get a batched timeline of a single metric with the default kwargs
Klaviyo::Metrics.get_metric_timeline(
  'METRIC_ID',
  since: nil,
  count: 100,
  sort: 'desc'
)

# export data for a single metric
Klaviyo::Metrics.get_metric_export(
  'METRIC_ID',
  start_date: nil,
  end_date: nil,
  unit: nil,
  measurement: nil,
  where: nil,
  by: nil,
  count: nil
)
```

How to use it with a Rails application?
---------------------------------------

To automatically insert the Klaviyo script in your Rails app, add this to your environment config file or create a new initializer for it:

```ruby
require 'rack/klaviyo'
config.middleware.use "Klaviyo::Client::Middleware", "YOUR_PUBLIC_KLAVIYO_API_TOKEN"
```

This will automatically insert the Klaviyo script at the bottom on your HTML page, right before the closing `body` tag.

To record customer actions directly from your backend, in your `application_controller` class add a method to initialize set your public and private API tokens.

```ruby
require 'klaviyo'

class ApplicationController < ActionController::Base
  Klaviyo.public_api_key = 'YOUR_PUBLIC_API_KEY'
  Klaviyo.private_api_key = 'YOUR_PRIVATE_API_KEY'
end
```

Then in your controllers where you'd like to record an event:

```ruby
Klaviyo::Public.track('Did something important',
  email: 'john.smith@example.com',
  properties:
  {
    key: 'value'
  }
)
```
