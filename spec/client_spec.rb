require 'spec_helper'

describe EasySMS::Client do
  describe '#initializer' do
    let(:valid_url) { 'http://account_uid:auth_token@example.com/accounts/account_uid' }

    it 'fails if no URL given' do
      expect{ EasySMS::Client.new }.to raise_error(RuntimeError)
    end

    it 'success if valid URL passed to initializer' do
      expect{ EasySMS::Client.new(valid_url) }.to_not raise_error
    end

    it 'reads EASYSMS_URL env variable if no URL passed to initializer' do
      allow(ENV).to receive(:[]).with('EASYSMS_URL').and_return(valid_url)
      expect{ EasySMS::Client.new }.to_not raise_error
    end
  end
end
