module EasySMS
  class MessageResource < Struct.new(:client)
    def create(attrs = {})
      res = client.post('/messages', attrs)

      JSON.parse(res).tap do |json|
        json['c_at'] = Time.parse(json['c_at']) if json['c_at']
      end
    end
  end
end
