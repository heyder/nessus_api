require_relative '../spec_helper'


describe NessusClient::Session do

  before(:context) do
    RSpec::Mocks.with_temporary_scope do
      @payload = {
        :username => 'username',
        :password => 'password'
      }
      # allow( NessusClient::Request ).to receive( :post ).with( '/session', @payload ).and_return( {'token' => 'token_test' }.to_json )
      # @nessus_session = NessusClient::Session.create( @payload[:username], @payload[:password] )  
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_return( Excon::Response.new({:body=> {'token' => 'token_test' }.to_json }) )
      allow_any_instance_of( NessusClient ).to receive(:new).and_return(  NessusClient.new( @payload ) )
      @nessus_client = NessusClient.new( @payload )
    end
  end

  context "initialize" do

    it "session has been create, without mock set_session" do
      # allow_any_instance_of( Excon::Connection ).to receive( :request ).and_return( Excon::Response.new({:body=> {'token' => 'token_test' }.to_json }) )
      expect( @nessus_client.has_session? ).to be(true)
    end

    # it "session has been created" do
    #   expect( @nessus_session ).to be_instance_of NessusClient::Session
    # end

    it "has a token" do
      expect( @nessus_client.session.nil?).to eql false
    end

    it "expect token string value" do
      expect( @nessus_client.headers ).to have_key('X-Cookie')
    end

    it "has NOT session token" do
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_return( Excon::Response.new({:body=> {}.to_json }) )

      expect{  NessusClient.new( @payload ) }.to raise_error( NessusClient::Error )
    end

  end

  context ".set_api_token" do

    it "should match valid api token" do
      allow_any_instance_of(  NessusClient::Request ).to receive( :get ).and_return( 'return"0000000A-0AAA-A000-A111-A11111111111"}' )
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_return( Excon::Response.new({:body=> {'token' => 'token_test' }.to_json } ) ) 
      allow_any_instance_of( NessusClient ).to receive( :new ).and_return(  NessusClient.new( @payload ) )
      nessus_client = NessusClient.new( @payload )
      # it is private
      expect{ nessus_client.set_api_token }.to raise_error( NoMethodError )
      expect( nessus_client.session ).to eq( true )
    end

    it "didn't match api token, shoud raise NessusClient::Error [Unable to get API Token. Some features wont work.]" do
      allow_any_instance_of(  NessusClient::Request ).to receive( :get ).and_return( 'doesnt_match_api_token_patern' )
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_return( Excon::Response.new({:body=> {'token' => 'token_test' }.to_json } ) ) 
      allow_any_instance_of( NessusClient ).to receive( :new ).and_return(  NessusClient.new( @payload ) )
      
      nessus_client = NessusClient.new( @payload )
           
      # expect{ nessus_client.set_api_token }.to raise_error( NessusClient::Error )
      expect( nessus_client.headers ).to_not have_key('X-API-Token' )
    end

  end
  
  context ".delete" do

    it "token should be nil after logout" do
      # NessusClient::Request.new({ :uri => 'http://ness.us' })
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_return( Excon::Response.new({:body=> {'token' => 'token_test' }.to_json } ) ) 
      allow_any_instance_of( NessusClient ).to receive( :new ).and_return(  NessusClient.new( @payload ) )
      
      nessus_client = NessusClient.new( @payload )
      nessus_client.logout
      expect( nessus_client.session ).to eq( false )

    end

  end

end




