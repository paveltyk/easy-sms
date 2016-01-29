require 'spec_helper'

describe 'EasySMS::Client#account' do
  let(:valid_url) { 'http://account_uid:auth_token@example.com/accounts/account_uid' }
  before(:each) { allow(ENV).to receive(:[]).with('EASYSMS_URL').and_return(valid_url) }

  describe '#get' do
    let(:valid_response) do
      {uid: '56a21298778404d264000000', sms_status_url: nil, plan: 'starter'}
    end

    it 'do GET to /' do
      stub_request(:get, valid_url + '/').to_return(status: 200, body: valid_response.to_json)

      account = EasySMS::Client.new.account.get
      expect(account.size).to eq(3)
      expect(account['uid']).to eq(valid_response[:uid])
      expect(account['sms_status_url']).to eq(valid_response[:sms_status_url])
      expect(account['plan']).to eq(valid_response[:plan])
    end
  end

  describe '#update' do
    let(:valid_response) do
      {uid: '56a21298778404d264000000', sms_status_url: 'http://api.example.com/sms-callback', plan: 'starter'}
    end

    it 'do PUT with "sms_status_url" to /' do
      params = {sms_status_url: 'http://api.example.com/sms-callback'}
      stub_request(:put, valid_url + '/').with(body: params.to_json).to_return(status: 200, body: valid_response.to_json)

      account = EasySMS::Client.new.account.update(params)
      expect(account.size).to eq(3)
      expect(account['uid']).to eq(valid_response[:uid])
      expect(account['sms_status_url']).to eq(valid_response[:sms_status_url])
      expect(account['plan']).to eq(valid_response[:plan])
    end
  end
end
