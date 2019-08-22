require_relative '../spec_helper'

describe Endpoint::Policies do
    before(:context) do
        @payload = {
          uri: 'http://ness.us',
          username: 'username',
          password: 'password'
        }
        @headers = {"Content-Type"=>"application/json", "User-Agent"=>"Mozilla/5.0 (Linux x86_64)"}
    end
    context ".policies" do
        it "successful get all policies" do
            allow_any_instance_of( NessusClient::Request ).to receive( :get ).with( {path: '/policies', headers: @headers}).and_return( 
                {
                    policy_id:'integer',
                    policy_name: 'string'
                }.to_json
            )
            # allow( Endpoint::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( Endpoint::Session.new( 'mock_auth_cookie' ) )
            allow_any_instance_of( Endpoint::Session ).to receive( :set_session ).with( 'username' , 'password' ).and_return( token='mock_auth_cookie' )
            allow_any_instance_of( NessusClient ).to receive(:new).and_return(  NessusClient.new( @payload ) )
      
            nessus_client = NessusClient.new( @payload )
            policies = Oj.load( nessus_client.policies )
      
            expect( policies ).to have_key( 'policy_id' )
            expect( policies["policy_name"]  ).to eq( 'string' )
        end
    end
end