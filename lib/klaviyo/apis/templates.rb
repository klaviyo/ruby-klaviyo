module Klaviyo
  class Templates < Client
    TEMPLATES = 'email-templates'
    CLONE = 'clone'
    RENDER = 'render'
    SEND = 'send'

    # Retrieve all email templates available.
    # @param person_id [String] the id of the profile
    # @return [JSON] A dictionary with a data property that contains an array of all the
    #   email templates. Each entry is a separate email template object. If no email templates exist,
    #   the resulting array will be empty. This request should never return an error.
    def self.get_templates
      v1_request(HTTP_GET, TEMPLATES)
    end

    # Creates a new email templates
    # @param template_name [String] the template name
    # @param template_html [String] the html used to create the body of the email
    # @return [JSON] The newly created Email Template object with summary information.
    def self.create_template(template_name, template_html)
      body = {
        :name => template_name,
        :html => template_html
      }

      v1_request(HTTP_POST, TEMPLATES, body)
    end

    # Updates a specific email template
    # @param template_id [String] the id of the template
    # @param kwargs [Key/value pairs] attributes to add/update in the template
    #   options include :name [String], :html [String]
    # @return [JSON] The updated Email Template object with summary information.
    def self.update_template_details(template_id, kwargs = {})
      path = "#{TEMPLATES}/#{template_id}"
      v1_request(HTTP_PUT, path, kwargs)
    end

    # Deletes a given template.
    # Note: This is a destructive operation and cannot be undone. Be careful when deleting objects.
    # @params template_id [String] the id of the template
    def self.delete_template(template_id)
      path = "#{TEMPLATE}/#{template_id}"
      v1_request(HTTP_DELETE, path)
    end

    # Creates a copy of a given template with a new name.
    # @param template_id [String] the id of the template you are cloning
    # @param new_template_name [String] the name of the newly created template
    # @return [JSON] The newly created Email Template object with summary information.
    def self.clone_template(template_id, new_template_name)
      path = "#{TEMPLATE}/#{template_id}/#{CLONE}"
      body = {
        :name => new_template_name
      }
      v1_request(HTTP_POST, path, body)
    end

    # Renders the specified template with the provided data and return HTML and text versions of
    #   the email.
    # @param template_id [String] the id of the template you are cloning
    # @param kwargs [Key/value pairs] attributes for the context your email template will be
    #   rendered with
    # @return [JSON] The Email Template object with an additional data property that contains both
    #   the HTML and text versions of the rendered template.
    def self.render_template(template_id, kwargs = {})
      path = "#{TEMPLATE}/#{template_id}/#{RENDER}"
      body = {
        :context => kwargs
      }
      v1_request(HTTP_POST, path, body)
    end

    # Renders the specified template with the provided data and then send the contents in an email
    # via the service specified.

    # NOTE: This API is intended to test templates only, and is rate limited to the following
    # thresholds:
    # 100 / hour
    # 1,000 / day
    # It is suggested that you use event or metric-triggered flows for more general use cases.

    # @param template_id [String] the id of the template you are cloning
    # @param sender [Key/Value pair] {:email => email to be sent from, :name => name of the sender}
    # @param to_email [String or JSON] Can either be just the email, or an encoded array of objects
    #   with "email" and "name" keys
    # @param subject [String] the subject of the email
    # @param kwargs [Key/value pairs] attributes for the context your email template will be
    #   rendered with
    # @return [JSON] The Email Template object with an additional data property that contains the
    #   status of the message. If successful, the status will be queued.
    def self.send_template(template_id, sender, recipient, subject, kwargs = {})
      path = "#{TEMPLATE}/#{template_id}/#{RENDER}"
      body = {
        :from_email => sender[:email],
        :from_name => sender[:name],
        :to => recipient,
        :subject => subject,
        :context => kwargs
      }
      v1_request(HTTP_POST, path, body)
    end
  end
end
