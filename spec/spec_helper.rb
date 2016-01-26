$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'webmock/rspec'
require 'easy_sms'

WebMock.disable_net_connect!
