require_relative 'spec_helper'

describe NessusClient do

  before(:context) do
    @payload = {
      uri: 'http://ness.us',
      username: 'username',
      password: 'password',
      ssl_verify_peer: false
    }
    token = %r{[a-z0-9]{48}}.random_example
    @mock_auth_token = {:token => token }
    @api_token = %r{([A-Z0-9]{8}-(?:[A-Z0-9]{4}-){3}[A-Z0-9]{12})}.random_example
    @mock_api_token = "return\"#{@api_token}\"\}"
  end
  
  it 'has a version number' do
    expect(NessusClient::VERSION).not_to be nil
  end

  context "initialize" do
    
    it "successful authentication and api token" do

      allow_any_instance_of( NessusClient::Request ).to receive( :get ).and_return( @mock_api_token )
      # session
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_return( Excon::Response.new({:body=> Oj.dump(@mock_auth_token) } ) ) 
      allow_any_instance_of( NessusClient ).to receive( :new ).and_return(  NessusClient.new( @payload ) )

      nessus_client = NessusClient.new( @payload )

      expect( nessus_client ).to be_instance_of NessusClient
      expect( nessus_client.has_session? ).to be(true)
      expect( nessus_client.headers ).to have_key('X-Cookie')
      expect( nessus_client.headers['X-Cookie'] ).to eq("token=#{@mock_auth_token[:token]}")
      expect( nessus_client.headers ).to have_key('X-API-Token')
      expect( nessus_client.headers['X-API-Token'] ).to eq(@api_token)

    end

  end

  context "status" do
    it "is ready" do
      
      allow_any_instance_of( NessusClient::Request ).to receive( :get ).with( {path: '/server/status', headers: be_kind_of(Hash)}).and_return( Oj.dump({:code => 200, :status => 'ready'}, mode: :compat) )
      allow_any_instance_of( Resource::Session ).to receive( :set_session ).with( 'username' , 'password' ).and_return( token='mock_auth_cookie' )
      allow_any_instance_of( NessusClient ).to receive(:new).and_return(  NessusClient.new( @payload ) )

      nessus_client = NessusClient.new( @payload )
      server_status = Oj.load( nessus_client.server_status )

      expect( server_status ).to have_key( 'status' )
      expect( server_status["code"]  ).to eq( 200 )

    end
  end
end

