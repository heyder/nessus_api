require_relative '../spec_helper'

describe Resource::Folders do
  before(:context) do
    @payload = {
      :uri => 'http://ness.us',
      :username => 'username',
      :password => 'password'
    }
  end
  context ".list_folders" do
    it "successful list folders" do
      allow_any_instance_of(NessusClient::Request).to receive(:get).with({ path: '/folders', headers: be_kind_of(Hash) }).and_return(
        Oj.dump({
                  "folders" => [
                    0 => {
                      "unread_count" => 0,
                      "custom" => 0,
                      "default_tag" => 0,
                      "type" => "trash",
                      "name" => "Trash",
                      "id" => 18
                    }
                  ]
                }, mode: :compat)
      )
      allow_any_instance_of(Resource::Session).to receive(:set_session).with('username', 'password').and_return(token = 'mock_auth_cookie')
      allow_any_instance_of(NessusClient).to receive(:new).and_return(NessusClient.new(@payload))

      nessus_client = NessusClient.new(@payload)
      folders = Oj.load(nessus_client.list_folders)

      expect(folders).to have_key('folders')
      expect(folders["folders"]).to be_instance_of(Array)
    end
  end
  context ".create_folder" do
    it "successful create folder" do
      allow_any_instance_of(NessusClient::Request).to receive(:post).with(
        { path: '/folders', payload: { :name => 'mock_folder_name' }, headers: be_kind_of(Hash) }
      ).and_return(Oj.dump({ id: 55 }, mode: :compat))
      allow_any_instance_of(Resource::Session).to receive(:set_session).with('username', 'password').and_return(token = 'mock_auth_cookie')
      allow_any_instance_of(NessusClient).to receive(:new).and_return(NessusClient.new(@payload))

      nessus_client = NessusClient.new(@payload)
      folder = Oj.load(nessus_client.create_folder('mock_folder_name'))

      expect(folder).to have_key('id')
      expect(folder["id"]).to eq(55)
    end
  end
end
