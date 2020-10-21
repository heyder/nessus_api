# frozen_string_literal: true

require_relative '../spec_helper'

describe Resource::Tokens do
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
  context '.token_status' do
    it 'successful get a token status' do
      export_uuid = '73376c41-1508-46b7-8587-483d159cd956'
      allow_any_instance_of(NessusClient::Request).to receive(
        :get
      ).with({ path: "/tokens/#{export_uuid}/status", headers: be_kind_of(Hash) }).and_return(
        Oj.dump({
                  "error": '',
                  "message": 'The download is ready.',
                  "status": 'ready'
                }, mode: :compat)
      )

      resp = Oj.load(@nessus_client.token_status(export_uuid))

      expect(resp).to have_key('status')
      expect(resp['status']).to eq('ready')
    end
  end
  context '.token_download' do
    it 'successful download a export request' do
      export_uuid = '73376c41-1508-46b7-8587-483d159cd956'
      allow_any_instance_of(NessusClient::Request).to receive(
        :get
      ).with({ path: "/tokens/#{export_uuid}/download", headers: be_kind_of(Hash) }).and_return(
        '<?xml version="1.0" ?>
        <NessusClientData_v2>
        <Policy>
        <policyName>Web App Tests</policyName>
        </Policy>
        <Report>
        </Report>
        </NessusClientData_v2>'
      )
      report = @nessus_client.token_download(export_uuid)
      expect(Nokogiri::XML(report).errors).to be_empty
    end
  end
end
