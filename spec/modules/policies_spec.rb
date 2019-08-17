require_relative '../spec_helper'

describe NessusApi::Policies do
    before(:context) do
        @payload = {
          uri: 'http://ness.us',
          username: 'username',
          password: 'password'
        }  
    end
    context ".policies" do
        it "successful get all policies" do
            allow_any_instance_of( NessusApi::Request ).to receive( :get ).with( '/policies').and_return( 
                {
                    policy_id:'integer',
                    policy_name: 'string'
                }.to_json
            )
            allow( NessusApi::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusApi::Session.new( 'mock_auth_cookie' ) )
            allow_any_instance_of( NessusApi ).to receive(:new).and_return(  NessusApi.new( @payload ) )
      
            nessus_api = NessusApi.new( @payload )
            policies = Oj.load( nessus_api.policies )
      
            expect( policies ).to have_key( 'policy_id' )
            expect( policies["policy_name"]  ).to eq( 'string' )
        end
    end
end