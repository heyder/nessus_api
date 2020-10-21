# frozen_string_literal: true

require_relative '../spec_helper'

describe Resource::Server do
  before(:context) do
    RSpec::Mocks.with_temporary_scope do
      @payload = {
        uri: 'http://ness.us',
        username: 'username',
        password: 'password'
      }
      allow_any_instance_of(Resource::Session).to receive(
        :set_session
        ).with('username', 'password').and_return('mock_auth_cookie')
      allow_any_instance_of(NessusClient).to receive(
        :new
      ).and_return(NessusClient.new(@payload))

      @nessus_client = NessusClient.new(@payload)
    end
  end
  context 'status' do
    it 'is ready' do
      allow_any_instance_of(NessusClient::Request).to receive(:get).with(
        { path: '/server/status', headers: be_kind_of(Hash) }
      ).and_return(
        Oj.dump({ code: 200, status: 'ready' }, mode: :compat)
      )

      server_status = Oj.load(@nessus_client.server_status)

      expect(server_status).to have_key('status')
      expect(server_status['code']).to eq(200)
    end
  end
  context 'server_properties' do
    it 'successfully get server properties' do
      allow_any_instance_of(NessusClient::Request).to receive(:get).with(
        { path: '/server/properties', headers: be_kind_of(Hash) }
      ).and_return(
        Oj.dump({
                  "nessus_type": 'Nessus Professional',
                  "server_version": '8.9.0',
                  "nessus_ui_build": '111',
                  "nessus_ui_version": '8.9.0',
                  "server_build": '11111'
                }, mode: :compat)
      )

      properties = Oj.load(@nessus_client.server_properties)

      expect(properties).to have_key('nessus_type')
      expect(properties['nessus_type']).to eq('Nessus Professional')
    end
  end
end
