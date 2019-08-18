
require_relative 'spec_helper'

describe NessusClient do

  before(:context) do
    @payload = {
      uri: 'http://ness.us',
      username: 'username',
      password: 'password'
    }  
  end
  
  it 'has a version number' do
    expect(NessusClient::VERSION).not_to be nil
  end

  context "initialize" do
    
    it "with successful auth and api token" do

      

      allow( NessusClient::Request ).to receive( :get ).with( '/nessus6.js').and_return( 'return"0000000A-0AAA-A000-A111-A11111111111"}' )
      allow( NessusClient::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusClient::Session.new( 'mock_auth_cookie' ) )
      allow_any_instance_of( NessusClient ).to receive( :new ).and_return(  NessusClient.new( @payload ) )

      nessus_client = NessusClient.new( @payload )

      expect( nessus_client ).to be_instance_of NessusClient
      expect( nessus_client.has_session? ).to be(true)
      expect( nessus_client.request.headers ).to have_key('X-Cookie')
      expect( nessus_client.request.headers['X-Cookie'] ).to eq('token=mock_auth_cookie')
      expect( nessus_client.request.headers ).to have_key('X-API-Token')
      expect( nessus_client.request.headers['X-API-Token'] ).to eq('0000000A-0AAA-A000-A111-A11111111111')

    end

    it "authentication failure" do
   
      allow( NessusClient::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusClient::Session.new( nil ) )
      allow_any_instance_of( NessusClient ).to receive( :new ).and_return(  NessusClient.new( @payload ) )

      nessus_client = NessusClient.new( @payload )

      expect( nessus_client ).to be_instance_of NessusClient
      expect( nessus_client.has_session? ).to be(false)

    end

    it "successful autentication but no api-token" do

      allow( NessusClient::Request ).to receive( :get ).with( '/nessus6.js').and_return( 'mock_invalid_api_token' )
      allow( NessusClient::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusClient::Session.new( 'mock_auth_cookie' ) )
      allow_any_instance_of( NessusClient ).to receive( :new ).and_return(  NessusClient.new( @payload ) )

      nessus_client = NessusClient.new( @payload )

      expect( nessus_client ).to be_instance_of NessusClient
      expect( nessus_client.has_session? ).to be(true)
      expect( nessus_client.request.headers ).to have_key('X-Cookie')
      expect( nessus_client.request.headers['X-Cookie'] ).to eq('token=mock_auth_cookie')
      expect( nessus_client.request.headers ).to_not have_key('X-API-Token')      
      
    end

  end

  context "status" do
    it "is ready" do
      
      allow_any_instance_of( NessusClient::Request ).to receive( :get ).with( '/server/status').and_return( {:code => 200, :status => 'ready'}.to_json )
      allow( NessusClient::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusClient::Session.new( 'mock_auth_cookie' ) )
      allow_any_instance_of( NessusClient ).to receive(:new).and_return(  NessusClient.new( @payload ) )

      nessus_client = NessusClient.new( @payload )
      server_status = Oj.load( nessus_client.status )

      expect( server_status ).to have_key( 'status' )
      expect( server_status["code"]  ).to eq( 200 )

    end
  end
end

