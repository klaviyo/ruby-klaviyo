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

Require the Klaviyo module in the file:

```ruby
# require the klaviyo module
require 'klaviyo'
```

Public:

```ruby
# set your public API key
@public = Klaviyo::Public.new('PUBLIC_API_KEY')

# used to track events
@public.track(
  'Filled out profile',
  email: 'someone@mailinator.com',
  properties: {
    'Added social accounts' : false
  }
)

# using a phone number to track events
@public.track(
  'TestedSMSContact',
  phone_number: '+15555555555',
  properties: {
    'Added social accounts' : false
  }
)

# used for identifying customers and managing profile properties
@public.identify(
  email: 'thomas.jefferson@mailinator.com',
  properties: {
    '$first_name': 'Thomas',
    '$last_name': 'Jefferson',
    'Plan': 'Premium'
  }
)

# using a POST request to track events
@public.track(
  'Filled out profile',
  method: 'post',
  email: 'someone@mailinator.com',
  properties: {
    'Added social accounts': false
  }
)
```

Lists:

```ruby
# create a new Lists instance and set the private API key
@lists = Klaviyo::Lists.new('PRIVATE_API_KEY')

# to add a new list
@lists.create_list('NEW_LIST_NAME')

# to get all lists
@lists.get_lists()

# to get list details
@lists.get_list_details('LIST_ID')

# to update a list name
@lists.update_list_details('LIST_ID', 'LIST_NAME_UPDATED')

# to delete a list
@lists.delete_list('LIST_ID')

# to check email address subscription status to a list
@lists.check_list_subscriptions(
  'LIST_ID',
  emails: ['test1@example.com'],
  phone_numbers: ['5555555555'],
  push_tokens: ['PUSH_TOKEN']
)

# to add subscribers to a list, this will follow the lists double opt in settings
@lists.add_subscribers_to_list(
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
@lists.unsubscribe_from_list(
  'LIST_ID',
  emails: ['test1@example.com']
)

# to add members to a list, this doesn't care about the list double opt in setting
@lists.add_to_list(
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
@lists.check_list_memberships(
  'LIST_ID',
  emails: ['test1@example.com'],
  phone_numbers: ['5555555555'],
  push_tokens: ['PUSH_TOKEN']
)

# to remove profiles from a list
@lists.remove_from_list(
  'LIST_ID',
  emails: ['test1@example.com'],
  phone_numbers: ['5555555555'],
  push_tokens: ['PUSH_TOKEN']
)

# to get exclusion emails from a list - marker is used for paginating
@lists.get_list_exclusions('LIST_ID', marker: 'EXAMPLE_MARKER')

# to get all members in a group or list
@lists.get_group_members('LIST_ID')
```

Profiles:

```ruby
# create a new Profiles instance and set the private API key
@profiles = Klaviyo::Profiles.new('PRIVATE_API_KEY')

# get profile id by email
@profiles.get_profile_id_by_email('EMAIL')

# get profile by profile_id
@profiles.get_person_attributes('PROFILE_ID')

# update a profile
@profiles.update_person_attributes(
  'PROFILE_ID',
  PropertyName1: 'value',
  PropertyName2: 'value'
)

# get all metrics for a profile with the default kwargs
@profiles.get_person_metrics_timeline(
  'PROFILE_ID',
  since: nil,
  count: 100,
  sort: 'desc'
)

# get all events of a metric for a profile with the default kwargs
@profiles.get_person_metric_timeline(
  'PROFILE_ID',
  'METRIC_ID',
  since: nil,
  count: 100,
  sort: 'desc'
)
```

Metrics:

```ruby
# create a new Metrics instance and set the private API key
@metrics = Klaviyo::Metrics.new('PRIVATE_API_KEY')

# get all metrics with the default kwargs
@metrics.get_metrics(page: 0, count: 100)

# get a batched timeline of all metrics with the default kwargs
@metrics.get_metrics_timeline(
  since: nil,
  count: 100,
  sort: 'desc'
)

# get a batched timeline of a single metric with the default kwargs
@metrics.get_metric_timeline(
  'METRIC_ID',
  since: nil,
  count: 100,
  sort: 'desc'
)

# export data for a single metric
@metrics.get_metric_export(
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

Campaigns:

```ruby
# create a new Campaigns instance and set the private API key
@campaigns = Klaviyo::Campaigns.new('PRIVATE_API_KEY')

# get Campaigns
@campaigns.get_campaigns()

# get specific Campaign details
@campaigns.get_campaign_details('CAMPAIGN_ID')

# send Campaign
@campaigns.send_campaign('CAMPAIGN_ID')

# cancel Campaign
@campaigns.cancel_campaign('CAMPAIGN_ID')
```

Email Templates:

```ruby
# create a new EmailTemplates instance and set the private API key
@emailTemplates = Klaviyo::EmailTemplates.new('PRIVATE_API_KEY')

# get templates
@emailTemplates.get_templates()

# create a new template
@emailTemplates.create_template(name: 'TEMPLATE_NAME', html: 'TEMPLATE_HTML')

# update template
# does not update drag & drop templates at this time
@emailTemplates.update_template(
  'TEMPLATE_ID',
  name: 'UPDATED_TEMPLATE_NAME',
  html: 'UPDATED_TEMPLATE_HTML'
)

# delete template
@emailTemplates.delete_template('TEMPLATE_ID')

# clone a template with a new name
@emailTemplates.clone_template('TEMPLATE_ID', 'NEW_TEMPLATE_NAME')

# render template - returns html and text versions of template
@emailTemplates.render_template(
  'TEMPLATE_ID',
  context: {
    name: 'RECIPIENT_NAME',
    email: 'RECIPIENT_EMAIL_ADDRESS'
  }
)

# send template
@emailTemplates.send_template(
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

Data Privacy:

```ruby
# create a new DataPrivacy instance and set the private API key
@dataPrivacy = Klaviyo::DataPrivacy.new('PRIVATE_API_KEY')

# delete profile by email
@dataPrivacy.request_profile_deletion('email','EMAIL')

# delete profile by phone number
@dataPrivacy.request_profile_deletion('phone_number','PHONE_NUMBER')

# delete profile by person id
@dataPrivacy.request_profile_deletion('person_id','PERSON_ID')
```

How to use it with a Rails application?
---------------------------------------

To automatically insert the Klaviyo script in your Rails app, add this to your environment config file or create a new initializer for it:

```ruby
require 'rack/klaviyo'
config.middleware.use "Klaviyo::Client::Middleware", "YOUR_PUBLIC_KLAVIYO_API_TOKEN"
```

This will automatically insert the Klaviyo script at the bottom on your HTML page, right before the closing `body` tag.

To record customer actions directly from your backend, in your `application_controller` class add a method to initialize and set your public API token.

```ruby
require 'klaviyo'

class ApplicationController < ActionController::Base
  @public = Klaviyo::Public.new('PUBLIC_API_KEY')
end
```

Then in your controllers where you'd like to record an event:

```ruby
@public.track('Did something important',
  email: 'john.smith@example.com',
  properties:
  {
    key: 'value'
  }
)
```
