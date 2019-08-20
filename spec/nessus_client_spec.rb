require_relative 'spec_helper'

describe NessusClient do

  before(:context) do
    @payload = {
      uri: 'http://ness.us',
      username: 'username',
      password: 'password',
      ssl_verify_peer: false
    }  
  end
  
  it 'has a version number' do
    expect(NessusClient::VERSION).not_to be nil
  end

  context "initialize" do
    
    it "successful authentication and api token" do

      allow_any_instance_of( NessusClient::Request ).to receive( :get ).and_return( 'return"0000000A-0AAA-A000-A111-A11111111111"}' )
      # session
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_return( Excon::Response.new({:body=> {'token' => 'mock_auth_cookie' }.to_json } ) ) 
      allow_any_instance_of( NessusClient ).to receive( :new ).and_return(  NessusClient.new( @payload ) )

      nessus_client = NessusClient.new( @payload )

      expect( nessus_client ).to be_instance_of NessusClient
      expect( nessus_client.has_session? ).to be(true)
      expect( nessus_client.headers ).to have_key('X-Cookie')
      expect( nessus_client.headers['X-Cookie'] ).to eq('token=mock_auth_cookie')
      expect( nessus_client.headers ).to have_key('X-API-Token')
      expect( nessus_client.headers['X-API-Token'] ).to eq('0000000A-0AAA-A000-A111-A11111111111')

    end

  end

  context "status" do
    it "is ready" do
      
      allow_any_instance_of( NessusClient::Request ).to receive( :get ).with( '/server/status', be_kind_of(Hash)).and_return( {:code => 200, :status => 'ready'}.to_json )
      allow_any_instance_of( NessusClient::Session ).to receive( :set_session ).with( 'username' , 'password' ).and_return( token='mock_auth_cookie' )
      allow_any_instance_of( NessusClient ).to receive(:new).and_return(  NessusClient.new( @payload ) )

      nessus_client = NessusClient.new( @payload )
      server_status = Oj.load( nessus_client.status )

      expect( server_status ).to have_key( 'status' )
      expect( server_status["code"]  ).to eq( 200 )

    end
  end
end

