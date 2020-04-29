# frozen_string_literal: true

require_relative '../spec_helper'

describe Resource::Policies do
  before(:context) do
    @payload = {
      uri: 'http://ness.us',
      username: 'username',
      password: 'password'
    }
  end
  context '.policies' do
    it 'successful get all policies' do
      allow_any_instance_of(NessusClient::Request).to receive(
        :get
      ).with({ path: '/policies', headers: be_kind_of(Hash) }).and_return(
        Oj.dump({
                  policy_id: 'integer',
                  policy_name: 'string'
                }, mode: :compat)
      )
      allow_any_instance_of(Resource::Session).to receive(
        :set_session
      ).with('username', 'password').and_return('mock_auth_cookie')
      allow_any_instance_of(NessusClient).to receive(
        :new
      ).and_return(NessusClient.new(@payload))

      nessus_client = NessusClient.new(@payload)
      policies = Oj.load(nessus_client.policies)

      expect(policies).to have_key('policy_id')
      expect(policies['policy_name']).to eq('string')
    end
  end
end
