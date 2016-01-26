module EasySMS
  class Client
    attr_reader :uri

    def initialize(url = nil)
      @url = url || ENV['EASYSMS_URL'] || ENV['EASY_SMS_URL']
      raise 'Resource URL not set. Please pass a valid URL to initializer, or set EASYSMS_URL environment variable.' unless @url
      @resource = RestClient::Resource.new(@url)
      @uri = URI.parse(@url)
    end

    def messages
      MessageResource.new(self)
    end

    def phone_numbers
      PhoneNumberResource.new(self)
    end

    def account
      AccountResource.new(self)
    end

    def get(path, attrs)
      begin
        #TODO: add attrs to url or let it be handled by RestClient
        @resource[path].get(content_type: :json, accept: :json)
      rescue RestClient::Exception => e
        json = JSON.parse(e.response) rescue nil
        raise Error.new([e, json].compact.join(' '))
      end
    end

    def post(path, attrs)
      begin
        @resource[path].post(attrs.to_json, content_type: :json, accept: :json)
      rescue RestClient::Exception => e
        json = JSON.parse(e.response) rescue nil
        raise Error.new([e, json].compact.join(' '))
      end
    end

    def put(path, attrs)
      begin
        @resource[path].put(attrs.to_json, content_type: :json, accept: :json)
      rescue RestClient::Exception => e
        json = JSON.parse(e.response) rescue nil
        raise Error.new([e, json].compact.join(' '))
      end
    end

    def delete(path)
      begin
        @resource[path].delete(content_type: :json, accept: :json)
      rescue RestClient::Exception => e
        json = JSON.parse(e.response) rescue nil
        raise Error.new([e, json].compact.join(' '))
      end
    end
  end
end
