require_relative '../spec_helper'

describe NessusClient::Policies do
    before(:context) do
        @payload = {
          uri: 'http://ness.us',
          username: 'username',
          password: 'password'
        }  
    end
    context ".policies" do
        it "successful get all policies" do
            allow_any_instance_of( NessusClient::Request ).to receive( :get ).with( '/policies').and_return( 
                {
                    policy_id:'integer',
                    policy_name: 'string'
                }.to_json
            )
            allow( NessusClient::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusClient::Session.new( 'mock_auth_cookie' ) )
            allow_any_instance_of( NessusClient ).to receive(:new).and_return(  NessusClient.new( @payload ) )
      
            nessus_client = NessusClient.new( @payload )
            policies = Oj.load( nessus_client.policies )
      
            expect( policies ).to have_key( 'policy_id' )
            expect( policies["policy_name"]  ).to eq( 'string' )
        end
    end
end