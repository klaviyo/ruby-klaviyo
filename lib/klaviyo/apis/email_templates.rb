module Klaviyo
  module EmailTemplates
    EMAIL_TEMPLATES = 'email-templates'
    EMAIL_TEMPLATE = 'email-template'
    CLONE = 'clone'
    RENDER = 'render'
    SEND = 'send'

    HTTP_DELETE = 'delete'
    HTTP_GET = 'get'
    HTTP_POST = 'post'
    HTTP_PUT = 'put'

    # Returns a list of all the email templates you've created.
    # The templates are returned in sorted order by name.
    # @return [List] of JSON formatted email template objects
    def get_templates(client)
      v1_request(HTTP_GET, EMAIL_TEMPLATES)
    end

    # Creates a new email template
    # @param :name [String] The name of the email template
    # @param :html [String] The HTML content for this template
    # @return [JSON] a JSON object containing information about the email template
    def create_template(name: nil, html: nil)
      params = {
        name: name,
        html: html
      }
      v1_request(HTTP_POST, EMAIL_TEMPLATES, content_type: CONTENT_URL_FORM, params: params)
    end

    # Updates the name and/or HTML content of a template. Only updates imported
    # HTML templates; does not currently update drag & drop templates
    # @param template_id [String] The id of the email template
    # @param :name [String] The name of the email template
    # @param :html [String] The HTML content for this template
    # @return [JSON] a JSON object containing information about the email template
    def update_template(template_id, name:, html:)
      path = "#{EMAIL_TEMPLATE}/#{template_id}"
      params = {
        name: name,
        html: html
      }
      v1_request(HTTP_PUT, path, **params)
    end

    # Deletes a given template.
    # @param template_id [String] The id of the email template
    # @return [JSON] a JSON object containing information about the email template
    def delete_template(template_id)
      path = "#{EMAIL_TEMPLATE}/#{template_id}"
      v1_request(HTTP_DELETE, path)
    end

    # Creates a copy of a given template with a new name
    # @param template_id [String] The id of the email template to copy
    # @param :name [String] The name of the newly cloned email template
    # @return [JSON] a JSON object containing information about the email template
    def clone_template(template_id, name:)
      path = "#{EMAIL_TEMPLATE}/#{template_id}/#{CLONE}"
      params = {
        name: name
      }
      v1_request(HTTP_POST, path, content_type: CONTENT_URL_FORM, params: params)
    end

    # Renders the specified template with the provided data and return HTML
    # and text versions of the email
    # @param template_id [String] The id of the email template to copy
    # @param :context [Hash] The context the email template will be rendered with
    # @return [JSON] a JSON object containing information about the email template
    def render_template(template_id, context: {})
      path = "#{EMAIL_TEMPLATE}/#{template_id}/#{RENDER}"
      params = {
        context: context
      }
      v1_request(HTTP_POST, path, content_type: CONTENT_URL_FORM, params: params)
    end

    # Renders the specified template with the provided data and then send the
    # contents in an email via the service specified
    # @param template_id [String] The id of the email template to copy
    # @param :from_email [String] The from email address; used in the reply-to header
    # @param :from_name [String] The name the email is sent from
    # @param :subject [String] The subject of the email template
    # @param :to [Mixed] The email this template is being sent to
    # @param :context [Hash] The context the email template will be rendered with
    # @return [JSON] a JSON object containing information about the email template
    def send_template(template_id, from_email:, from_name:, subject:, to:, context: {})
      path = "#{EMAIL_TEMPLATE}/#{template_id}/#{SEND}"
      params = {
        from_email: from_email,
        from_name: from_name,
        subject: subject,
        to: to,
        context: context
      }
      v1_request(HTTP_POST, path, content_type: CONTENT_URL_FORM, params: params)
    end
  end
end
