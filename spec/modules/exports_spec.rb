require_relative '../spec_helper'

describe NessusClient::Exports do
    before(:context) do
        @payload = {
          uri: 'http://ness.us',
          username: 'username',
          password: 'password'
        }  
        @scan_id = '2776e999-1f5b-45b9-2e15-65a7be35b2e3ab8f7ecb158c480e'
    end
    context ".export_request" do
        it "successful export request" do
            allow_any_instance_of( NessusClient::Session ).to receive( :set_session ).with( 'username' , 'password' ).and_return( token='mock_auth_cookie' )
            allow_any_instance_of( NessusClient::Request ).to receive( :post ).with( "/scans/#{@scan_id}/export", {:format => 'nessus' } ).and_return( 
                {
                    :export_uuid => "73376c41-1508-46b7-8587-483d159cd956"
                }.to_json
            )
            allow_any_instance_of( NessusClient ).to receive(:new).and_return(  NessusClient.new( @payload ) )

            nessus_client = NessusClient.new( @payload )
            export_request = Oj.load( nessus_client.export_request( @scan_id, 'nessus' ) )
      
            expect( export_request ).to have_key( 'export_uuid' )
            expect( export_request["export_uuid"]  ).to eq( "73376c41-1508-46b7-8587-483d159cd956" )
        end
    end
    context ".export_status" do
        it "successful export status" do
            allow_any_instance_of( NessusClient::Request ).to receive( :get ).with( '/tokens/export_id/status').and_return( 
                {
                    :status => "PROCESSING",    
                    :chunks_available => [
                        1,
                        2
                    ],
                    :chunks_failed => [],
                    :chunks_cancelled => []
                }.to_json
            )
            allow_any_instance_of( NessusClient::Session ).to receive( :set_session ).with( 'username' , 'password' ).and_return( token='mock_auth_cookie' )
            allow_any_instance_of( NessusClient ).to receive(:new).and_return(  NessusClient.new( @payload ) )
      
            nessus_client = NessusClient.new( @payload )
            export_status = Oj.load( nessus_client.export_status('export_id') )
      
            expect( export_status ).to have_key( 'status' )
            expect( export_status["chunks_available"]  ).to be_instance_of( Array )
        end
    end
    context ".export_download" do
        it "successful export_download" do
            allow_any_instance_of( NessusClient::Request ).to receive( :get ).with( "/tokens/export_id/download").and_return({:output => 'export_data_body'}.to_json)
            allow_any_instance_of( NessusClient::Session ).to receive( :set_session ).with( 'username' , 'password' ).and_return( token='mock_auth_cookie' )
            allow_any_instance_of( NessusClient ).to receive(:new).and_return(  NessusClient.new( @payload ) )
      
            nessus_client = NessusClient.new( @payload )
            export = Oj.load( nessus_client.export_download( 'export_id' ) )
      
            expect( export ).to have_key( 'output' )  
        end
    end
end