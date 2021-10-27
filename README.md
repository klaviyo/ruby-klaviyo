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
    'Added social accounts' : false
  }
)

# using a phone number to track events
Klaviyo::Public.track(
  'TestedSMSContact',
  phone_number: '+15555555555',
  properties: {
    'Added social accounts' : false
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

# using a POST request to track events
Klaviyo::Public.track(
  'Filled out profile',
  method: 'post',
  email: 'someone@mailinator.com',
  properties: {
    'Added social accounts': false
  }
)
```
Thread Safety - Public API
---------------------------
For Public API requests, you can set the Public API key per-request by using the 'token' keyword argument.  This allows you to send track or identify requests to different Klaviyo accounts.

```ruby
# sending a track request to account xXyYzZ
Klaviyo::Public.track(
  'Filled out profile',
  token: 'PUBLIC_API_TOKEN',
  email: 'someone@mailinator.com',
  properties: {
    'Added social accounts' : false
  }
)

# sending an identify request to account xXyYzZ
Klaviyo::Public.identify(
  email: 'thomas.jefferson@mailinator.com',
  token: 'PUBLIC_API_TOKEN',
  properties: {
    '$first_name': 'Thomas',
    '$last_name': 'Jefferson',
    'Plan': 'Premium'
  }
)
```
Thread Safety - Private APIs
----------------------------
For all of the APIs listed below, each request will accept an optional 'api_key' keyword argument that can be used to set the Private API key for that request.  Examples are provided below. All of the following methods will accept the 'api_key' keyword argument.

### Lists:

```ruby
# to add a new list
Klaviyo::Lists.create_list('NEW_LIST_NAME')

# add a new list using a different api key
Klaviyo::Lists.create_list('NEW_LIST_NAME', api_key: 'pk_EXAMPLE_API_KEY')

# to get all lists
Klaviyo::Lists.get_lists()

# to get all lists using a different api key
Klaviyo::Lists.get_lists(api_key: 'pk_EXAMPLE_API_KEY')

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

# check email address subscription status to a list using a different api key
Klaviyo::Lists.check_list_subscriptions(
  'LIST_ID',
  api_key: 'pk_EXAMPLE_API_KEY',
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

# to get exclusion emails from a list - marker is used for paginating using a different api key
Klaviyo::Lists.get_list_exclusions(
  'LIST_ID',
  marker: 'EXAMPLE_MARKER',
  api_key: 'pk_EXAMPLE_API_KEY'
)

# to get all members in a group or list
Klaviyo::Lists.get_group_members('LIST_ID')
```

### Profiles:

```ruby
# get profile id by email
Klaviyo::Profiles.get_profile_id_by_email('EMAIL')

# get profile id by email using a different api key
Klaviyo::Profiles.get_profile_id_by_email('EMAIL', api_key: 'pk_EXAMPLE_API_KEY')

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

# get all metrics for a profile with the default kwargs using a different api key
Klaviyo::Profiles.get_person_metrics_timeline(
  'PROFILE_ID',
  since: nil,
  count: 100,
  sort: 'desc',
  api_key: 'pk_EXAMPLE_API_KEY'
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

### Metrics:

```ruby
# get all metrics with the default kwargs
Klaviyo::Metrics.get_metrics(page: 0, count: 100)

# get all metrics with the default kwargs using a different api key
Klaviyo::Metrics.get_metrics(page: 0, count: 100, api_key: 'pk_EXAMPLE_API_KEY')

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

# get a batched timeline of a single metric with the default kwargs using a different api key
Klaviyo::Metrics.get_metric_timeline(
  'METRIC_ID',
  since: nil,
  count: 100,
  sort: 'desc',
  api_key: 'pk_EXAMPLE_API_KEY'
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

### Campaigns:

```ruby
# get Campaigns
Klaviyo::Campaigns.get_campaigns()

# get Campaigns using a different api key
Klaviyo::Campaigns.get_campaigns(api_key: 'pk_EXAMPLE_API_KEY')

# get specific Campaign details
Klaviyo::Campaigns.get_campaign_details('CAMPAIGN_ID')

# send Campaign
Klaviyo::Campaigns.send_campaign('CAMPAIGN_ID')

# cancel Campaign
Klaviyo::Campaigns.cancel_campaign('CAMPAIGN_ID')

# cancel Campaign using a different API key
Klaviyo::Campaigns.cancel_campaign('CAMPAIGN_ID', api_key: 'pk_EXAMPLE_API_KEY')
```

### Email Templates:

```ruby
# get templates
Klaviyo::EmailTemplates.get_templates()

# get templates using a different api key
Klaviyo::EmailTemplates.get_templates(api_key: 'pk_EXAMPLE_API_KEY')

# create a new template
Klaviyo::EmailTemplates.create_template(name: 'TEMPLATE_NAME', html: 'TEMPLATE_HTML')

# update template
# does not update drag & drop templates at this time
Klaviyo::EmailTemplates.update_template(
  'TEMPLATE_ID',
  name: 'UPDATED_TEMPLATE_NAME',
  html: 'UPDATED_TEMPLATE_HTML'
)

# delete template
Klaviyo::EmailTemplates.delete_template('TEMPLATE_ID')

# delete template using a different API key
Klaviyo::EmailTemplates.delete_template('TEMPLATE_ID', api_key: 'pk_EXAMPLE_API_KEY')

# clone a template with a new name
Klaviyo::EmailTemplates.clone_template('TEMPLATE_ID', 'NEW_TEMPLATE_NAME')

# render template - returns html and text versions of template
Klaviyo::EmailTemplates.render_template(
  'TEMPLATE_ID',
  context: {
    name: 'RECIPIENT_NAME',
    email: 'RECIPIENT_EMAIL_ADDRESS'
  }

# render template - returns html and text versions of template using a different api key
Klaviyo::EmailTemplates.render_template(
  'TEMPLATE_ID',
  api_key: 'pk_EXAMPLE_API_KEY',
  context: {
    name: 'RECIPIENT_NAME',
    email: 'RECIPIENT_EMAIL_ADDRESS'
  }
)

# send template
Klaviyo::EmailTemplates.send_template(
  'TEMPLATE_ID',
  from_email: 'FROM_EMAIL_ADDRESS',
  from_name: 'FROM_EMAIL_NAME',
  subject: 'EMAIL_SUBJECT',
  to: 'RECIPIENT_EMAIL_ADDRESS',
  context: {
    name: 'RECIPIENT_NAME',
    email: 'RECIPIENT_EMAIL_ADDRESS'
  }
)
```

### Data Privacy:

```ruby
# delete profile by email
Klaviyo::DataPrivacy.request_profile_deletion('email','EMAIL')

# delete profile by email using a different api key
Klaviyo::DataPrivacy.request_profile_deletion('email','EMAIL', api_key: 'pk_EXAMPLE_API_KEY')

# delete profile by phone number
Klaviyo::DataPrivacy.request_profile_deletion('phone_number','PHONE_NUMBER')

# delete profile by phone number using a different api key
Klaviyo::DataPrivacy.request_profile_deletion('phone_number','PHONE_NUMBER', api_key: 'pk_EXAMPLE_API_KEY')

# delete profile by person id
Klaviyo::DataPrivacy.request_profile_deletion('person_id','PERSON_ID')

# delete profile by person id using a different api key
Klaviyo::DataPrivacy.request_profile_deletion('person_id','PERSON_ID', api_key: 'pk_EXAMPLE_API_KEY')
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
