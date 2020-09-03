require 'pry'

module Klaviyo
  class Client
    @@domain = 'https://a.klaviyo.com/api'
    @@v1 = 'v1'
    @@v2 = 'v2'

    private

    def self.request(method, path, kwargs = {})
      if path == 'track' || path == 'identify'
        params = build_params(kwargs)
        url = "#{@@domain}/#{path}?#{params}"
        res = Faraday.get(url)
      else
        check_private_api_key_exists()
        url = "#{@@domain}/#{path}"
        con = Faraday.new(
          url: url,
          headers: {
            'Content-type' => 'application/json'
        })
        response = con.send(method.downcase) do |req|
          req.body = kwargs[:body].to_json || nil
        end
        puts response.body
      end
    end

    def self.v1_request(method, path, kwargs = {})
      defaults = {:page => nil, :count => nil, :since => nil, :sort => nil}
      params = defaults.merge(kwargs)
      query_params = encode_params(params)
      url_params = "api_key=#{Klaviyo.private_api_key}#{query_params}"
      puts "url_params is #{url_params}"
      full_path = "#{@@v1}/#{path}?#{url_params}"
      puts "full path is #{full_path}"
      request(method, full_path)
    end

    def self.v2_request(method, path, kwargs = {})
      path = "#{@@v2}/#{path}"
      key = {
        "api_key": "#{@@private_api_key}"
      }
      data = {}
      data[:body] = key.merge(kwargs)
      request(method, path, data)
    end

    def self.build_params(params)
      "data=#{Base64.encode64(JSON.generate(params)).gsub(/\n/,'')}"
    end

    def self.check_private_api_key_exists()
      if !Klaviyo.private_api_key
        raise KlaviyoError.new(NO_PRIVATE_API_KEY_ERROR)
      end
    end

    def self.encode_params(kwargs)
      kwargs.select!{|k, v| v}
      params = URI.encode_www_form(kwargs)

      if !params.empty?
        return "&#{params}"
      end
    end
  end
end
