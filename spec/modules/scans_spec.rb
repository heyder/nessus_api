require_relative '../spec_helper'

describe NessusClient::Scans do
    before(:context) do
        @payload = {
          uri: 'http://ness.us',
          username: 'username',
          password: 'password'
        }  
    end
    context ".list_scans" do
        it "successful list scans" do
            allow_any_instance_of( NessusClient::Request ).to receive( :get ).with( '/scans', nil, nil ).and_return( 
                {
                    folders:[
                        0 => {
                            unread_count:0,
                            custom:0,
                            default_tag:0,
                            type:"trash",
                            name:"Trash",
                            id:8
                        }
                    ],
                    scans:[
                        0 => {
                            legacy:false,
                            permissions:128,
                            type:nil,
                            read:true,
                            last_modification_date:1430934526,
                            creation_date:1430933086,
                            status:"imported",
                            uuid:"2776e999-1f5b-45b9-2e15-65a7be35b2e3ab8f7ecb158c480e",
                            shared:false,
                            user_permissions:128,
                            owner:"user2@example.com",
                            schedule_uuid:"0fafc7a8-c5f6-fe9d-68b9-4d60ab0d9d2cf60557ee0e264228",
                            timezone:nil,
                            rrules:nil,
                            starttime:nil,
                            enabled:false,
                            control:false,
                            name:"KitchenSinkScan",
                            id:11
                        }
                    ],
                    "timestamp":1544146142
                }.to_json
            )
            allow( NessusClient::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusClient::Session.new( 'mock_auth_cookie' ) )
            allow_any_instance_of( NessusClient ).to receive(:new).and_return(  NessusClient.new( @payload ) )
      
            nessus_client = NessusClient.new( @payload )
            scans = Oj.load( nessus_client.scans )
      
            expect( scans ).to have_key( 'scans' )
            expect( scans["scans"]  ).to be_instance_of( Array )
        end
    end
   
end