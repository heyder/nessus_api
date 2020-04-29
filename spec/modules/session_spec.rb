# frozen_string_literal: true

require_relative '../spec_helper'

describe Resource::Session do
  before(:context) do
    RSpec::Mocks.with_temporary_scope do
      @payload = {
        username: 'username',
        password: 'password'
      }
      x_cookie_regex = Regexp.new('[a-z0-9]{48}')
      @x_cookie_string = x_cookie_regex.random_example
      @mock_auth_token = Oj.dump(
        {
          token: @x_cookie_string
        }, mode: :compat
      )
      api_token_regex = Regexp.new('([A-Z0-9]{8}-(?:[A-Z0-9]{4}-){3}[A-Z0-9]{12})')
      @mock_api_token = "return\"#{api_token_regex.random_example}\"\}"
    end
  end

  context 'successfully initialize' do
    before :each do
      allow_any_instance_of(NessusClient::Request).to receive(
        :get
      ).with(
        {
          headers: {
            'Content-Type' => 'application/json',
            'User-Agent' => 'NessusClient::Request - rubygems.org nessus_client',
            'X-Cookie' => "token=#{@x_cookie_string}"
          },
          path: '/nessus6.js'
        }
      ).and_return(@mock_api_token)
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).with(
        {
          body: '{"username":"username","password":"password"}',
          expects: [200, 201],
          headers: {
            'Content-Type' => 'application/json',
            'User-Agent' => 'NessusClient::Request - rubygems.org nessus_client'
          },
          method: :post,
          path: '/session',
          query: nil
        }
      ).and_return(
        Excon::Response.new({ body: @mock_auth_token })
      )
      allow_any_instance_of(NessusClient).to receive(
        :new
      ).and_return(
        NessusClient.new(@payload)
      )
      @nessus_client = NessusClient.new(@payload)
    end
    it 'session has been create' do
      expect(@nessus_client.has_session?).to be_truthy
    end

    it 'has a token' do
      expect(@nessus_client.session.nil?).to be_falsy
    end

    it 'expect token string value' do
      expect(@nessus_client.headers).to have_key('X-Cookie')
      expect(@nessus_client.headers['X-Cookie']).to eql("token=#{@x_cookie_string}")
    end

    it 'token should be nil after logout' do
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).and_return(Excon::Response.new({ body: @mock_auth_token }))
      allow_any_instance_of(NessusClient).to receive(
        :new
      ).and_return(
        NessusClient.new(@payload)
      )
      nessus_client = NessusClient.new(@payload)
      nessus_client.logout
      expect(
        nessus_client.session
      ).to be_falsy
    end
  end

  context 'unsuccessfully initialize' do
    it 'has NOT session token' do
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).with(
        {
          body: '{"username":"username","password":"password"}',
          expects: [200, 201],
          headers: {
            'Content-Type' => 'application/json',
            'User-Agent' => 'NessusClient::Request - rubygems.org nessus_client'
          },
          method: :post,
          path: '/session',
          query: nil
        }
      ).and_return(
        Excon::Response.new(
          {
            body: Oj.dump({})
          }
        )
      )
      expect {
        NessusClient.new(@payload)
      }.to raise_error(NessusClient::Error)
    end
  end

  context '.set_api_token' do
    it 'should match valid api token' do
      allow_any_instance_of(NessusClient::Request).to receive(
        :get
      ).and_return(@mock_api_token)
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).and_return(
        Excon::Response.new({ body: @mock_auth_token })
      )
      allow_any_instance_of(NessusClient).to receive(
        :new
      ).and_return(
        NessusClient.new(@payload)
      )
      nessus_client = NessusClient.new(@payload)
      # it is private
      expect {
        nessus_client.set_api_token
      }.to raise_error(NoMethodError)
      expect(
        nessus_client.session
      ).to eq(true)
    end

    it "didn't match api token, shoud raise NessusClient::Error" do
      allow_any_instance_of(NessusClient::Request).to receive(
        :get
      ).and_return('doesnt_match_api_token_patern')
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).and_return(
        Excon::Response.new({ body: @mock_auth_token })
      )
      allow_any_instance_of(NessusClient).to receive(
        :new
      ).and_return(
        NessusClient.new(@payload)
      )
      nessus_client = NessusClient.new(@payload)
      expect(
        nessus_client.headers
      ).to_not have_key('X-API-Token')
    end
  end
end
