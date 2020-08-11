
module Klaviyo
  class Lists < Client
    @@all = 'all'
    @@exclusions = 'exclusions'
    @@group = 'group'
    @@list = 'list'
    @@lists = 'lists'
    @@members = 'members'
    @@subscribe = 'subscribe'

    def self.create_list(list_name)
      path = "#{@@lists}"
      body = {
        :list_name => list_name
      }
      v2_request('POST', path, body)
    end

    def self.get_lists()
      path = "#{@@lists}"
      v2_request('GET', path)
    end

    def self.get_list_details(list_id)
      path = "#{@@list}/#{list_id}"
      v2_request('GET', path)
    end

    def self.update_list_details(list_id, list_name)
      path = "#{@@list}/#{list_id}"
      body = {
        :list_name => list_name
      }
      v2_request('PUT', path, body)
    end

    def self.delete_list(list_id)
      path = "#{@@list}/#{list_id}"
      v2_request('DELETE', path)
    end

    def self.check_list_subscriptions(list_id, kwargs = {})
      path = "#{@@list}/#{list_id}/#{@@subscribe}"
      v2_request('GET', path, kwargs)
    end

    def self.unsubscribe_from_list(list_id, kwargs = {})
      path = "#{@@list}/#{list_id}/#{@@subscribe}"
      v2_request('DELETE', path, kwargs)
    end

    def self.add_to_list(list_id, kwargs = {})
      path = "#{@@list}/#{list_id}/#{@@members}"
      v2_request('POST', path, kwargs)
    end

    def self.check_list_memberships(list_id, kwargs = {})
      path = "#{@@list}/#{list_id}/#{@@members}"
      v2_request('GET', path, kwargs)
    end

    def self.remove_from_list(list_id, kwargs = {})
      path = "#{@@list}/#{list_id}/#{@@members}"
      v2_request('DELETE', path, kwargs)
    end

    def self.get_list_exclusions(list_id, kwargs = {})
      path = "#{@@list}/#{list_id}/#{@@exclusions}/#{@@all}"
      v2_request('GET', path, kwargs)
    end

    def self.get_group_members(list_id)
      path = "#{@@group}/#{list_id}/#{@@members}/#{@@all}"
      v2_request('GET', path)
    end
  end
end
