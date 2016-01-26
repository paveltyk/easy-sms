require 'spec_helper'

describe 'EasySMS::Client.phone_numbers' do
  let(:valid_url) { 'http://account_uid:auth_token@example.com/accounts/account_uid' }
  before(:each) { allow(ENV).to receive(:[]).with('EASYSMS_URL').and_return(valid_url) }

  describe '#list' do
    let(:valid_response) do
      [{uid: '56a21298778404d264000000', phone_number: '+15005550006', primary: true, inbound_sms_url: nil, country_code: 'US'}]
    end

    it 'do GET to /phone_numbers' do
      stub_request(:get, valid_url + '/phone_numbers').to_return(status: 200, body: valid_response.to_json)

      phone_numbers = EasySMS::Client.new.phone_numbers.list
      phone_numbers.size.should eq(1)

      phone_number = phone_numbers.first
      phone_number.size.should eq(5)
      phone_number['uid'].should eq(valid_response.first[:uid])
      phone_number['phone_number'].should eq(valid_response.first[:phone_number])
      phone_number['primary'].should eq(valid_response.first[:primary])
      phone_number['inbound_sms_url'].should eq(valid_response.first[:inbound_sms_url])
      phone_number['country_code'].should eq(valid_response.first[:country_code])
    end
  end

  describe '#create' do
    let(:valid_response) do
      {uid: '56a21298778404d264000000', phone_number: '+15005550006', primary: true, inbound_sms_url: nil, country_code: 'US'}
    end

    it 'do POST to /phone_numbers' do
      stub_request(:post, valid_url + '/phone_numbers').to_return(status: 200, body: valid_response.to_json)

      phone_number = EasySMS::Client.new.phone_numbers.create
      phone_number.size.should eq(5)
      phone_number['uid'].should eq(valid_response[:uid])
      phone_number['phone_number'].should eq(valid_response[:phone_number])
      phone_number['primary'].should eq(valid_response[:primary])
      phone_number['inbound_sms_url'].should eq(valid_response[:inbound_sms_url])
      phone_number['country_code'].should eq(valid_response[:country_code])
    end

    it 'do POST to /phone_numbers with params' do
      params = {country_code: 'BY', pattern: '*******1*0'}
      stub_request(:post, valid_url + '/phone_numbers').with(body: params.to_json).to_return(status: 200, body: valid_response.to_json)

      phone_number = EasySMS::Client.new.phone_numbers.create(params)
      phone_number.size.should eq(5)
      phone_number['uid'].should eq(valid_response[:uid])
      phone_number['phone_number'].should eq(valid_response[:phone_number])
      phone_number['primary'].should eq(valid_response[:primary])
      phone_number['inbound_sms_url'].should eq(valid_response[:inbound_sms_url])
      phone_number['country_code'].should eq(valid_response[:country_code])
    end
  end

  describe '#update' do
    let(:valid_response) do
      {uid: '56a21298778404d264000000', phone_number: '+15005550006', primary: true, inbound_sms_url: 'http://api.example.com/inbound-sms', country_code: 'US'}
    end

    it 'do PUT to /phone_numbers/56a21298778404d264000000' do
      params = {inbound_sms_url: 'http://api.example.com/inbound-sms'}
      stub_request(:put, "#{valid_url}/phone_numbers/#{valid_response[:uid]}").with(body: params.to_json).to_return(status: 200, body: valid_response.to_json)

      phone_number = EasySMS::Client.new.phone_numbers.update(valid_response[:uid], params)
      phone_number.size.should eq(5)
      phone_number['uid'].should eq(valid_response[:uid])
      phone_number['phone_number'].should eq(valid_response[:phone_number])
      phone_number['primary'].should eq(valid_response[:primary])
      phone_number['inbound_sms_url'].should eq(valid_response[:inbound_sms_url])
      phone_number['country_code'].should eq(valid_response[:country_code])
    end
  end

  describe '#delete' do
    let(:valid_response) do
      {uid: '56a21298778404d264000000', phone_number: '+15005550006', primary: true, inbound_sms_url: nil, country_code: 'US'}
    end

    it 'do DELETE to /phone_numbers/56a21298778404d264000000' do
      stub_request(:delete, "#{valid_url}/phone_numbers/#{valid_response[:uid]}").to_return(status: 200, body: valid_response.to_json)

      phone_number = EasySMS::Client.new.phone_numbers.delete(valid_response[:uid])
      phone_number.size.should eq(5)
      phone_number['uid'].should eq(valid_response[:uid])
      phone_number['phone_number'].should eq(valid_response[:phone_number])
      phone_number['primary'].should eq(valid_response[:primary])
      phone_number['inbound_sms_url'].should eq(valid_response[:inbound_sms_url])
      phone_number['country_code'].should eq(valid_response[:country_code])
    end
  end
end
