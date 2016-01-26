module EasySMS
  class AccountResource < Struct.new(:client)
    def get
      res = client.get('', {})

      JSON.parse(res).tap do |json|
        json['c_at'] = Time.parse(json['c_at']) if json['c_at']
      end
    end

    def update(attrs = {})
      res = client.put('', attrs)

      JSON.parse(res)
    end
  end
end
