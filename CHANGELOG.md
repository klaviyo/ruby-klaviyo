## CHANGELOG

### 2.3.0

* Added ability to set API key in request without setting Klaviyo.private_api_key

### 2.2.0

* Added feature to set API key per-request for public APIs

### 2.1.0

* Remove exception for checking API keys
* Added warnings for API keys
* Added Ruby_Klaviyo user agent

### 2.0.9

* Added ability to make POST requests to public api
* Added public API key validation

### 2.0.8

* Update data privacy request for compatibility

### 2.0.7

* Update functions with kwargs to support Ruby 3+

### 2.0.6

* Update track request for compatibility w/ Ruby v3.0+
* Update track request to accept time as integer

### 2.0.5

* Add basic templates API support
* Add CGI escape to public requests

### 2.0.4

* Add basic support for Data Privacy API and people/search endpoint

### 2.0.3

* Add basic support for Campaigns API

### 2.0.2

* Add SMS profile support to Public API requests

### 2.0.0

* Add Lists v2, Profiles, and Metrics API compatibility
* Redesign structure to use specific API classes
* Add Faraday requests package

### 1.0.0

* Add Public Track and Identify methods
