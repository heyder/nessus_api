require_relative '../spec_helper'

describe NessusClient::Folders do
    before(:context) do
        @payload = {
          :uri => 'http://ness.us',
          :username => 'username',
          :password => 'password'
        }  
    end
    context ".list_folders" do
        it "successful list folders" do
            
            allow_any_instance_of( NessusClient::Request ).to receive( :get ).with( '/folders').and_return( 
                {
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
                }.to_json
            )
            allow_any_instance_of( NessusClient::Session ).to receive( :set_session ).with( 'username' , 'password' ).and_return( token='mock_auth_cookie' )
            allow_any_instance_of( NessusClient ).to receive(:new).and_return(  NessusClient.new( @payload ) )
      
            nessus_client = NessusClient.new( @payload )
            folders = Oj.load( nessus_client.list_folders )
      
            expect( folders ).to have_key( 'folders' )
            expect( folders["folders"]  ).to be_instance_of( Array )
        end
    end
    context ".create_folder" do
        it "successful create folder" do
            allow_any_instance_of( NessusClient::Request ).to receive( :post ).with( '/folders',  {:name => 'mock_folder_name' } ).and_return( { id: 55 }.to_json )
            allow_any_instance_of( NessusClient::Session ).to receive( :set_session ).with( 'username' , 'password' ).and_return( token='mock_auth_cookie' )
            allow_any_instance_of( NessusClient ).to receive(:new).and_return(  NessusClient.new( @payload ) )
      
            nessus_client = NessusClient.new( @payload )
            folder = Oj.load( nessus_client.create_folder( 'mock_folder_name' ) )
      
            expect( folder ).to have_key( 'id' )  
            expect( folder["id"]  ).to eq( 55 )
        end
    end
end