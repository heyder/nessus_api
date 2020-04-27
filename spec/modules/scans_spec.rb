require_relative '../spec_helper'
require 'excon'

describe Resource::Scans do
  before(:context) do
    @payload = {
      uri: 'http://ness.us',
      username: 'username',
      password: 'password'
    }
  end
  before :each do
    @list_of_scans = Oj.load(Oj.dump({
                                       folders: [
                                         {
                                           unread_count: 0,
                                           custom: 0,
                                           default_tag: 0,
                                           type: "trash",
                                           name: "Trash",
                                           id: 8
                                         }
                                       ],
                                       scans: [
                                         {
                                           legacy: false,
                                           permissions: 128,
                                           type: nil,
                                           read: true,
                                           last_modification_date: 1430934526,
                                           creation_date: 1430933086,
                                           status: "imported",
                                           uuid: "2776e999-1f5b-45b9-2e15-65a7be35b2e3ab8f7ecb158c480e",
                                           shared: false,
                                           user_permissions: 128,
                                           owner: "user2@example.com",
                                           schedule_uuid: "0fafc7a8-c5f6-fe9d-68b9-4d60ab0d9d2cf60557ee0e264228",
                                           timezone: nil,
                                           rrules: nil,
                                           starttime: nil,
                                           enabled: false,
                                           control: false,
                                           name: "KitchenSinkScan",
                                           id: 11
                                         }
                                       ],
                                       "timestamp": 1544146142
                                     }, mode: :compat))
  end
  context ".list_scans" do
    it "successful list scans" do
      allow_any_instance_of(NessusClient::Request).to receive(:get).with({ path: '/scans', query: nil, headers: be_kind_of(Hash) }).and_return(@list_of_scans)
      allow_any_instance_of(Resource::Session).to receive(:set_session).with('username', 'password').and_return(token = 'mock_auth_cookie')
      allow_any_instance_of(NessusClient).to receive(:new).and_return(NessusClient.new(@payload))

      nessus_client = NessusClient.new(@payload)
      scans = nessus_client.scans

      expect(scans).to have_key('scans')
      expect(scans["scans"]).to be_instance_of(Array)
    end
  end
  context ".scan_details" do
    it "successful get scan detail" do
      allow_any_instance_of(NessusClient::Request).to receive(:get).with(
        { path: "/scans/scan_id", query: { "history_id" => 9 }, headers: be_kind_of(Hash) }
      ).and_return(
        Oj.dump({
                  info: {
                    owner: "user2@example.com",
                    name: "KitchenSinkScan",
                    no_target: false,
                    folder_id: 9
                  }
                }, mode: :compat)
      )

      allow_any_instance_of(Resource::Session).to receive(:set_session).with('username', 'password').and_return(token = 'mock_auth_cookie')
      allow_any_instance_of(NessusClient).to receive(:new).and_return(NessusClient.new(@payload))

      nessus_client = NessusClient.new(@payload)
      scan_details = Oj.load(nessus_client.scan_details('scan_id', 9))
      expect(scan_details).to have_key('info')
    end
  end
  context ".launch_by_name" do
    it "successful launch " do
      allow_any_instance_of(NessusClient::Request).to receive(:get).with({ path: "/scans", query: nil, headers: be_kind_of(Hash) }).and_return(@list_of_scans)

      allow_any_instance_of(Resource::Session).to receive(:set_session).with('username', 'password').and_return(token = 'mock_auth_cookie')
      allow_any_instance_of(NessusClient).to receive(:new).and_return(NessusClient.new(@payload))
      allow_any_instance_of(Excon::Connection).to receive(:request).and_return(Excon::Response.new(
                                                                                 {
                                                                                   :body => Oj.dump({
                                                                                                      scan_uuid: "e7f6c3f2-1718-4451-b459-1e8aa2ec6cdf"
                                                                                                    }, mode: :compat)
                                                                                 }
                                                                               ))
      nessus_client = NessusClient.new(@payload)
      scan = nessus_client.launch_by_name('KitchenSinkScan', ['127.0.0.1'])
      expect(scan).to have_key('scan_uuid')
    end
  end

  context ".get_scan_by_name" do
    it "successful launch " do
      allow_any_instance_of(NessusClient::Request).to receive(:get).with({ path: "/scans", query: nil, headers: be_kind_of(Hash) }).and_return(@list_of_scans)

      allow_any_instance_of(Resource::Session).to receive(:set_session).with('username', 'password').and_return(token = 'mock_auth_cookie')
      allow_any_instance_of(NessusClient).to receive(:new).and_return(NessusClient.new(@payload))

      nessus_client = NessusClient.new(@payload)
      scan_id = nessus_client.get_scan_by_name('KitchenSinkScan')
      expect(scan_id).to eq(11)
    end
  end
end
