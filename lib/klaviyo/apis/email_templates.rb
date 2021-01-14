module Klaviyo
  class EmailTemplates < Client
    EMAIL_TEMPLATES = 'email-templates'
    CLONE = 'clone'
    RENDER = 'render'
    SEND = 'send'

    # Returns a list of all the email templates you've created.
    # The templates are returned in sorted order by name.
    # @return [List] of JSON formatted email template objects
    def self.get_templates()
      v1_request(HTTP_GET, EMAIL_TEMPLATES)
    end

    # Creates a new email template
    # @param :name [String] The name of the email template
    # @param :html [String] The HTML content for this template
    # @return [JSON] a JSON object containing information about the email template
    def self.create_template(name:, html:)
      params = {
        name: name,
        html: html
      }
      v1_request(HTTP_POST, EMAIL_TEMPLATES, params)
    end

    # Updates the name and/or HTML content of a template. Only updates imported
    # HTML templates; does not currently update drag & drop templates
    # @param template_id [String] The id of the email template
    # @param :name [String] The name of the email template
    # @param :html [String] The HTML content for this template
    # @return [JSON] a JSON object containing information about the email template
    def self.update_template(template_id, name:, html:)
      path = "#{EMAIL_TEMPLATES}/#{template_id}"
      params = {
        name: name,
        html: html
      }
      v1_request(HTTP_PUT, path, params)
    end

    # Deletes a given template.
    # @param template_id [String] The id of the email template
    # @return [JSON] a JSON object containing information about the email template
    def self.delete_template(template_id)
      path = "#{EMAIL_TEMPLATES}/#{template_id}"
      v1_request(HTTP_DELETE, path)
    end

    # Creates a copy of a given template with a new name
    # @param template_id [String] The id of the email template to copy
    # @param :name [String] The name of the newly cloned email template
    # @return [JSON] a JSON object containing information about the email template
    def self.clone_template(template_id, name:)
      path = "#{EMAIL_TEMPLATES}/#{template_id}/#{CLONE}"
      params = {
        name: name,
        html: html
      }
      v1_request(HTTP_POST, path, params)
    end

    # Renders the specified template with the provided data and return HTML
    # and text versions of the email
    # @param template_id [String] The id of the email template to copy
    # @param :context [Hash] The context the email template will be rendered with
    # @return [JSON] a JSON object containing information about the email template
    def self.render_template(template_id, context: {})
      path = "#{EMAIL_TEMPLATES}/#{template_id}/#{RENDER}"
      params = {
        context: context
      }
      v1_request(HTTP_POST, path, params)
    end

    # Renders the specified template with the provided data and then send the
    # contents in an email via the service specified
    # @param template_id [String] The id of the email template to copy
    # @param :from_email [String] The from email address; used in the reply-to header
    # @param :from_name [String] The name the email is sent from
    # @param :subject [String] The subject of the email template
    # @param :to [Mixed] The to the email template will be rendered with
    # @param :context [Hash] The context the email template will be rendered with
    # @return [JSON] a JSON object containing information about the email template
    def self.send_template(template_id, from_email:, from_name:, subject:, to:, context: {})
      path = "#{EMAIL_TEMPLATES}/#{template_id}/#{SEND}"
      params = {
        from_email: '',
        from_name: '',
        subject: '',
        to: '',
        context: context
      }
      v1_request(HTTP_POST, path, params)
    end
  end
end
