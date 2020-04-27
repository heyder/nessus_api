require_relative '../spec_helper'

describe Resource::Session do
  before(:context) do
    RSpec::Mocks.with_temporary_scope do
      @payload = {
        :username => 'username',
        :password => 'password'
      }
      @mock_auth_token = Oj.dump({ :token => %r{[a-z0-9]{48}}.random_example }, mode: :compat)
      @mock_api_token = "return\"#{%r{([A-Z0-9]{8}-(?:[A-Z0-9]{4}-){3}[A-Z0-9]{12})}.random_example}\"\}"
      allow_any_instance_of(Excon::Connection).to receive(:request).and_return(Excon::Response.new({ :body => @mock_auth_token }))
      allow_any_instance_of(NessusClient).to receive(:new).and_return(NessusClient.new(@payload))
      @nessus_client = NessusClient.new(@payload)
    end
  end

  context "initialize" do
    it "session has been create, without mock set_session" do
      expect(@nessus_client.has_session?).to be(true)
    end

    it "has a token" do
      expect(@nessus_client.session.nil?).to eql false
    end

    it "expect token string value" do
      expect(@nessus_client.headers).to have_key('X-Cookie')
    end

    it "has NOT session token" do
      allow_any_instance_of(Excon::Connection).to receive(:request).and_return(Excon::Response.new({ :body => Oj.dump({}) }))
      expect { NessusClient.new(@payload) }.to raise_error(NessusClient::Error)
    end
  end

  context ".set_api_token" do
    it "should match valid api token" do
      allow_any_instance_of(NessusClient::Request).to receive(:get).and_return(@mock_api_token)
      allow_any_instance_of(Excon::Connection).to receive(:request).and_return(Excon::Response.new({ :body => @mock_auth_token }))
      allow_any_instance_of(NessusClient).to receive(:new).and_return(NessusClient.new(@payload))
      nessus_client = NessusClient.new(@payload)
      # it is private
      expect { nessus_client.set_api_token }.to raise_error(NoMethodError)
      expect(nessus_client.session).to eq(true)
    end

    it "didn't match api token, shoud raise NessusClient::Error [Unable to get API Token. Some features wont work.]" do
      allow_any_instance_of(NessusClient::Request).to receive(:get).and_return('doesnt_match_api_token_patern')
      allow_any_instance_of(Excon::Connection).to receive(:request).and_return(Excon::Response.new({ :body => @mock_auth_token }))
      allow_any_instance_of(NessusClient).to receive(:new).and_return(NessusClient.new(@payload))
      nessus_client = NessusClient.new(@payload)
      expect(nessus_client.headers).to_not have_key('X-API-Token')
    end
  end

  context ".delete" do
    it "token should be nil after logout" do
      allow_any_instance_of(Excon::Connection).to receive(:request).and_return(Excon::Response.new({ :body => @mock_auth_token }))
      allow_any_instance_of(NessusClient).to receive(:new).and_return(NessusClient.new(@payload))
      nessus_client = NessusClient.new(@payload)
      nessus_client.logout
      expect(nessus_client.session).to eq(false)
    end
  end
end
