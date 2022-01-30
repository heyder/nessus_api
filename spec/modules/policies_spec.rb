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
  before :each do
    @policy_name = 'policy_name'
    @policy_id = 123

    @list_of_policies = Oj.load(
      Oj.dump(
        {
          policies: [
            { is_scap: 0,
              has_credentials: 1,
              no_target: 'false',
              plugin_filters: nil,
              template_uuid: 'ad629e16-03b6-8c1d-cef6-ef8c9dd3c658d24bd260ef5f9e66',
              description: nil,
              name: @policy_name,
              owner: 'user',
              visibility: 'private',
              shared: 0,
              user_permissions: 128,
              last_modification_date: 1_601_564_546,
              creation_date: 1_601_561_642,
              owner_id: 2,
              id: @policy_id }
          ]
        }, mode: :compat
      )
    )

    @credential_id = '962'

    @default_credential = {
      add: {},
      edit:
        {
          "#{@credential_id}":
            {
              username: 'default_username',
              auth_method: 'Password',
              password: 'default_password'
            }
        },
      delete: {}
    }

    @policy = Oj.load(
      Oj.dump(
        {
          plugins:
            {},
          settings:
            @list_of_policies['policies'].first,
          uuid: {},
          credentials: @default_credential
        }, mode: :compat
      )
    )

    allow_any_instance_of(NessusClient::Request).to receive(
      :get
    ).with({ path: '/policies', headers: be_kind_of(Hash) }).and_return(@list_of_policies)

    allow_any_instance_of(NessusClient::Request).to receive(
      :get
    ).with({ path: "/policies/#{@policy_id}", headers: be_kind_of(Hash) }).and_return(@policy)

    allow_any_instance_of(Resource::Session).to receive(
      :set_session
    ).with('username', 'password').and_return('mock_auth_cookie')

    allow_any_instance_of(NessusClient).to receive(
      :new
    ).and_return(NessusClient.new(@payload))

    @nessus_client = NessusClient.new(@payload)
  end

  context '.policies' do
    it 'successful get all policies' do
      policies = @nessus_client.policies
      expect(policies).to have_key('policies')
      expect(policies['policies'].first['id']).to eq(@policy_id)
    end
    it 'successful get a policy id by name' do
      policy_id = @nessus_client.get_policy_id_by_name(@policy_name)
      expect(policy_id).to eq(@policy_id)
    end

    it 'successful get a policy by name' do
      policy = @nessus_client.get_policy_by_name(@policy_name)
      expect(policy).to have_key('settings')
    end

    it 'successful get all credentials of one policy' do
      credentials = @nessus_client.list_credentials_by_policy_name(@policy_name)
      # binding.pry
      expect(credentials).to be_a_kind_of(Hash)
      expect(credentials).to have_key('edit')
      expect(credentials['edit']).to have_key(@credential_id)
    end

    it 'update a policy' do
      allow_any_instance_of(NessusClient::Request).to receive(
        :put
      ).with(
        { path: "/policies/#{@policy_id}",
          headers: be_kind_of(Hash),
          payload: be_kind_of(Hash) }
      ).and_return(nil)
      new_credential = {
        "credentials": {
          "add": {},
          "edit": {
            "962": {
              "username": 'new_username',
              "auth_method": 'Password',
              "password": 'new_password'
            }
          },
          "delete": {}
        }
      }
      # TODO: - test whether the policy has been updated.
      policy = @nessus_client.update_policy_by_name(@policy_name, new_credential)
      expect(policy).to be_nil
    end
  end
end
