require 'spec_helper'

describe 'EasySMS::Client#messages' do
  let(:valid_url) { 'http://account_uid:auth_token@example.com/accounts/account_uid' }
  before(:each) { allow(ENV).to receive(:[]).with('EASYSMS_URL').and_return(valid_url) }

  describe '#create' do
    let(:valid_response) do
      {uid: '56a21298778404d264000000', to: '+15005550006', from: nil, body: 'RSpec Easy SMS', status: 'pending', error_message: nil, c_at: '2016-01-22 14:53:04 UTC'}
    end

    it 'do POST to /messages' do
      stub_request(:post, valid_url + '/messages').to_return(status: 200, body: valid_response.to_json)

      message = EasySMS::Client.new.messages.create

      expect(message.size).to eq(7)
      expect(message['uid']).to eq(valid_response[:uid])
      expect(message['to']).to eq(valid_response[:to])
      expect(message['from']).to eq(valid_response[:from])
      expect(message['body']).to eq(valid_response[:body])
      expect(message['status']).to eq(valid_response[:status])
      expect(message['c_at']).to eq(Time.parse(valid_response[:c_at]))
      expect(message['error_message']).to eq(valid_response[:error_message])
    end
  end
end
