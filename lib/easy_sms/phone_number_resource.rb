module EasySMS
  class PhoneNumberResource < Struct.new(:client)
    def list(attrs = {})
      res = client.get('/phone_numbers', attrs)

      JSON.parse(res)
    end

    def create(attrs = {})
      res = client.post('/phone_numbers', attrs)

      JSON.parse(res)
    end

    def update(uid, attrs = {})
      res = client.put("/phone_numbers/#{uid}", attrs)

      JSON.parse(res)
    end

    def delete(uid)
      res = client.delete("/phone_numbers/#{uid}")

      JSON.parse(res)
    end
  end
end
