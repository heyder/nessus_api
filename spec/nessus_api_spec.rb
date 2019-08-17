
require_relative 'spec_helper'

describe NessusApi do

  before(:context) do
    @payload = {
      uri: 'http://ness.us',
      username: 'username',
      password: 'password'
    }  
  end
  
  it 'has a version number' do
    expect(NessusApi::VERSION).not_to be nil
  end

  context "initialize" do
    
    it "with successful auth and api token" do

      

      allow( NessusApi::Request ).to receive( :get ).with( '/nessus6.js').and_return( 'return"0000000A-0AAA-A000-A111-A11111111111"}' )
      allow( NessusApi::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusApi::Session.new( 'mock_auth_cookie' ) )
      allow_any_instance_of( NessusApi ).to receive( :new ).and_return(  NessusApi.new( @payload ) )

      nessus_api = NessusApi.new( @payload )

      expect( nessus_api ).to be_instance_of NessusApi
      expect( nessus_api.has_session? ).to be(true)
      expect( nessus_api.request.headers ).to have_key('X-Cookie')
      expect( nessus_api.request.headers['X-Cookie'] ).to eq('token=mock_auth_cookie')
      expect( nessus_api.request.headers ).to have_key('X-API-Token')
      expect( nessus_api.request.headers['X-API-Token'] ).to eq('0000000A-0AAA-A000-A111-A11111111111')

    end

    it "authentication failure" do
   
      allow( NessusApi::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusApi::Session.new( nil ) )
      allow_any_instance_of( NessusApi ).to receive( :new ).and_return(  NessusApi.new( @payload ) )

      nessus_api = NessusApi.new( @payload )

      expect( nessus_api ).to be_instance_of NessusApi
      expect( nessus_api.has_session? ).to be(false)

    end

    it "successful autentication but no api-token" do

      allow( NessusApi::Request ).to receive( :get ).with( '/nessus6.js').and_return( 'mock_invalid_api_token' )
      allow( NessusApi::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusApi::Session.new( 'mock_auth_cookie' ) )
      allow_any_instance_of( NessusApi ).to receive( :new ).and_return(  NessusApi.new( @payload ) )

      nessus_api = NessusApi.new( @payload )

      expect( nessus_api ).to be_instance_of NessusApi
      expect( nessus_api.has_session? ).to be(true)
      expect( nessus_api.request.headers ).to have_key('X-Cookie')
      expect( nessus_api.request.headers['X-Cookie'] ).to eq('token=mock_auth_cookie')
      expect( nessus_api.request.headers ).to_not have_key('X-API-Token')      
      
    end

  end

  context "status" do
    it "is ready" do
      
      allow_any_instance_of( NessusApi::Request ).to receive( :get ).with( '/server/status').and_return( {:code => 200, :status => 'ready'}.to_json )
      allow( NessusApi::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusApi::Session.new( 'mock_auth_cookie' ) )
      allow_any_instance_of( NessusApi ).to receive(:new).and_return(  NessusApi.new( @payload ) )

      nessus_api = NessusApi.new( @payload )
      server_status = Oj.load( nessus_api.status )

      expect( server_status ).to have_key( 'status' )
      expect( server_status["code"]  ).to eq( 200 )

    end
  end
end

