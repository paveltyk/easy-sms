# Easy SMS

The Easy SMS gem is a wrapper for Easy SMS API. Currently Easy SMS API available as a Heroku add-on [Easy SMS](https://elements.heroku.com/addons/easysms) only.

## Using with Ruby/Rails

First of all you will need to install the easy-sms gem. And add it to a Gemfile if needed.

```
$ gem install easy-sms
```

### Sending SMS

You can send SMS right away with the `ENV['EASYSMS_URL']` and 'easy-sms' gem installed in your app. No additional configuration required.

Use `EasySMS::Client#messages.create(options)` to send SMS. Options:

* `to` - required. Recipient phone number in [E.164](http://en.wikipedia.org/wiki/E.164) format. Example: '+12067450316'
* `from` - optional. Sender phone number in [E.164](http://en.wikipedia.org/wiki/E.164) format. Example: '+12067450316'
* `body` - required. The text body of the message. Up to 1600 characters long.

```ruby
require 'easy-sms'

# By default initializer will use the EASYSMS_URL config variable to configure the client instance.
client = EasySMS::Client.new
puts client.messages.create to: '+12067450316', body: 'Hello from Easy SMS.' #=> {"body"=>"Hello from Easy SMS.", "c_at"=>2016-01-25 13:58:38 UTC, "from"=>nil, "status"=>"pending", "to"=>"+12067450316", "uid"=>"56a62a0ebbf109000c000000"}
# The received SMS can be seen at: http://sms-receive.net/12067450316-USA (free web service to receive SMS online)
```

Note the status of SMS is 'pending', which mean the SMS is not delivered yet. It will take a few seconds to process the SMS. You may receive HTTP POST requests to the status callback URL once SMS delivery status change. To do so, please specify the `sms_status_url` for your account. [Read more](#configuring-easy-sms-account)

### Creating and releasing phone numbers

Use `EasySMS::Client#phone_numbers.create(options)` to create a phone number. Options:

* `country_code` - optional. Two-letter country code of the phone number. Default 'US'
* `pattern` - optional. The pattern of the phone number. Default is nil. Example: '*******654'
* `inbound_sms_url` - optional. The callback URL to be triggered when your phone number receives SMS. Example: 'http://api.example.com/sms/callback'

```ruby
require 'easy-sms'

client = EasySMS::Client.new
phone_number = client.phone_numbers.create #=> {"inbound_sms_url"=>nil, "phone_number"=>"+12183011654", "primary"=>true, "uid"=>"56a630d53017290006000000", "country_code"=>"US"}
puts "Purchased phone number #{phone_number['phone_number']}"
client.phone_numbers.delete(phone_number['uid'])
puts "Released phone number #{phone_number['phone_number']}"
```

The `EasySMS::Client#phone_numbers.delete(uid)` method is used to release a phone number. This method accepts one argument - phone number UID *(the one returned by EasySMS::Client#phone_numbers.create)*.

### Receiving SMS

Any inbound SMS to one of your phone numbers will trigger a HTTP POST request to your callback URL. You may set the callback url on the phone number instance via the `EasySMS::Client#phone_numbers.update` method, or pass the `inbound_sms_url` option to `EasySMS::Client#phone_numbers.create` when you create a phone number.

`EasySMS::Client#phone_numbers.update(uid, options)` accepts phone number UID and options:

* `inbound_sms_url` - optional. The callback URL to be triggered when your phone number receives SMS. Example: 'http://api.example.com/sms/callback'

```ruby
require 'easy-sms'

client = EasySMS::Client.new
phone_numbers = client.phone_numbers.list
uid = phone_numbers.list.first['uid']
client.phone_numbers.update(uid, inbound_sms_url: 'http://api.example.com/sms/callback') #=> {message_uid: '56a21298778404d264000000', to: '+12183011654', from: '+12183011699', body: 'Hello there!', direction: 'inbound', c_at: '2016-01-22 14:53:04 UTC'}
```

The POST request to your callback URL will include these parameters:

* `message_uid` - UID of the message. A 24 characters string.
* `to` - recipient phone number (one of your phone numbers) in [E.164](http://en.wikipedia.org/wiki/E.164) format. Example: '+12067450316'
* `from` - sender phone number in [E.164](http://en.wikipedia.org/wiki/E.164) format. Example: '+12067450399'
* `body` - text body of SMS.
* `direction` - 'inbound'.
* `c_at` - time when SMS was received. Example: '2016-01-22 14:53:04 UTC'

### Configuring Easy SMS Account

You may want to fine tune your account. To check current account state run `EasySMS::client.account.get`. The result is a hash with valuable information for current account status and configuration.

Use `EasySMS::client.account.update(options)` to update your account configuration. Options:

* `sms_status_url` - optional. The callback URL to be triggered when SMS status change. Example: ‘http://api.example.com/sms-status/callback’

```ruby
client = EasySMS::Client.new
client.account.get #=> {"plan"=>"gold", "sms_status_url"=>nil, "uid"=>"56a21186778404d266000001"}
client.account.update(sms_status_url: 'http://api.example.com/sms-status/callback') #=> {"plan"=>"gold", "sms_status_url"=>"http://api.example.com/sms-status/callback", "uid"=>"56a21186778404d266000001"}
```

## Local Setup

After provisioning the add-on it’s necessary to locally replicate the config vars so your development environment can operate against the service.

Use the **Foreman** gem for example to run a commands within environment loaded from `.env` file. Add the `EASYSMS_URL` variable to your `.env` file.

```
EASYSMS_URL=https://<account_id>:<token>@api.easysmsapp.com/accounts/<account_id>
```

Though less portable it’s also possible to run a script using `export EASYSMS_URL=https://<account_id>:<token>@api.easysmsapp.com/accounts/<account_id> ruby script.rb`.

