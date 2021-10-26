module Klaviyo
  class EmailTemplates < Client
    EMAIL_TEMPLATES = 'email-templates'
    EMAIL_TEMPLATE = 'email-template'
    CLONE = 'clone'
    RENDER = 'render'
    SEND = 'send'

    # Returns a list of all the email templates you've created.
    # The templates are returned in sorted order by name.
    # @kwarg :api_key [String] private API key for this request
    # @return [List] of JSON formatted email template objects
    def self.get_templates(api_key: nil)
      v1_request(HTTP_GET, EMAIL_TEMPLATES, api_key: api_key)
    end

    # Creates a new email template
    # @param :name [String] The name of the email template
    # @param :html [String] The HTML content for this template
    # @kwarg :api_key [String] private API key for this request
    # @return [JSON] a JSON object containing information about the email template
    def self.create_template(name: nil, html: nil, api_key: nil)
      params = {
        name: name,
        html: html
      }
      v1_request(HTTP_POST, EMAIL_TEMPLATES, api_key: api_key, content_type: CONTENT_URL_FORM, params: params)
    end

    # Updates the name and/or HTML content of a template. Only updates imported
    # HTML templates; does not currently update drag & drop templates
    # @param template_id [String] The id of the email template
    # @param :name [String] The name of the email template
    # @param :html [String] The HTML content for this template
    # @kwarg :api_key [String] private API key for this request
    # @return [JSON] a JSON object containing information about the email template
    def self.update_template(template_id, name:, html:, api_key: nil)
      path = "#{EMAIL_TEMPLATE}/#{template_id}"
      params = {
        name: name,
        html: html
      }
      v1_request(HTTP_PUT, path, api_key: api_key, **params)
    end

    # Deletes a given template.
    # @param template_id [String] The id of the email template
    # @kwarg :api_key [String] private API key for this request
    # @return [JSON] a JSON object containing information about the email template
    def self.delete_template(template_id, api_key: nil)
      path = "#{EMAIL_TEMPLATE}/#{template_id}"
      v1_request(HTTP_DELETE, path, api_key: api_key)
    end

    # Creates a copy of a given template with a new name
    # @param template_id [String] The id of the email template to copy
    # @param :name [String] The name of the newly cloned email template
    # @kwarg :api_key [String] private API key for this request
    # @return [JSON] a JSON object containing information about the email template
    def self.clone_template(template_id, name:, api_key: nil)
      path = "#{EMAIL_TEMPLATE}/#{template_id}/#{CLONE}"
      params = {
        name: name
      }
      v1_request(HTTP_POST, path, api_key: api_key, content_type: CONTENT_URL_FORM, params: params)
    end

    # Renders the specified template with the provided data and return HTML
    # and text versions of the email
    # @param template_id [String] The id of the email template to copy
    # @param :context [Hash] The context the email template will be rendered with
    # @kwarg :api_key [String] private API key for this request
    # @return [JSON] a JSON object containing information about the email template
    def self.render_template(template_id, context: {}, api_key: nil)
      path = "#{EMAIL_TEMPLATE}/#{template_id}/#{RENDER}"
      params = {
        context: context
      }
      v1_request(HTTP_POST, path, api_key: api_key, content_type: CONTENT_URL_FORM, params: params)
    end

    # Renders the specified template with the provided data and then send the
    # contents in an email via the service specified
    # @param template_id [String] The id of the email template to copy
    # @param :from_email [String] The from email address; used in the reply-to header
    # @param :from_name [String] The name the email is sent from
    # @param :subject [String] The subject of the email template
    # @param :to [Mixed] The email this template is being sent to
    # @param :context [Hash] The context the email template will be rendered with
    # @kwarg :api_key [String] private API key for this request
    # @return [JSON] a JSON object containing information about the email template
    def self.send_template(template_id, from_email:, from_name:, subject:, to:, context: {}, api_key: nil)
      path = "#{EMAIL_TEMPLATE}/#{template_id}/#{SEND}"
      params = {
        from_email: from_email,
        from_name: from_name,
        subject: subject,
        to: to,
        context: context
      }
      v1_request(HTTP_POST, path, api_key: api_key, content_type: CONTENT_URL_FORM, params: params)
    end
  end
end
