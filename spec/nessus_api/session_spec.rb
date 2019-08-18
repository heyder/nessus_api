require_relative '../spec_helper'

describe NessusClient::Session do

  before(:context) do
    RSpec::Mocks.with_temporary_scope do
      @payload = {
        :username => 'username',
        :password => 'password'
      }
      allow( NessusClient::Request ).to receive( :post ).with( '/session', @payload ).and_return( {'token' => 'token_test' }.to_json )
      @nessus_session = NessusClient::Session.create( @payload[:username], @payload[:password] )  
    end
  end

  context "initialize" do

    it "session has been created" do
      expect( @nessus_session ).to be_instance_of NessusClient::Session
    end

    it "has a token" do
      expect( @nessus_session.token.nil?).to eql false
    end

    it "expect token string value" do
      expect( @nessus_session.token ).to eq ('token_test')
    end

    it "has NOT session token" do
      allow( NessusClient::Request ).to receive( :post ).with( '/session', @payload ).and_return( {}.to_json )
      expect{ NessusClient::Session.create( @payload[:username], @payload[:password] ) }.to raise_error( NessusClient::Error )
    end

  end

  context ".set_api_token" do

    it "should match valid api token" do
      NessusClient::Request.new({ :uri => 'http://ness.us' })
      allow( NessusClient::Request ).to receive( :get ).with( '/nessus6.js').and_return( 'return"0000000A-0AAA-A000-A111-A11111111111"}' )
      allow( NessusClient::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusClient::Session.new('lhebs') )
      
      session = NessusClient::Session.create( @payload[:username], @payload[:password] ) 
      session.set_api_token
      expect( session.api_token ).to eq( '0000000A-0AAA-A000-A111-A11111111111' )
    end

    it "didn't match api token, shoud raise NessusClient::Error [Unable to get API Token. Some features wont work.]" do
      NessusClient::Request.new({ :uri => 'http://ness.us' })
      allow( NessusClient::Request ).to receive( :get ).with( '/nessus6.js').and_return( 'this_sring_doesnt_match_the_token' )
      allow( NessusClient::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusClient::Session.new('lhebs') )

      session = NessusClient::Session.create( @payload[:username], @payload[:password] ) 
      expect{ session.set_api_token }.to raise_error( NessusClient::Error )
      expect( session.api_token ).to eq( nil )
    end

  end
  
  context ".delete" do

    it "token should be nil after logout" do
      # NessusClient::Request.new({ :uri => 'http://ness.us' })
      allow( NessusClient::Request ).to receive( :delete ).with( '/session', nil).and_return('')
      allow( NessusClient::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusClient::Session.new('lhebs') )

      session = NessusClient::Session.create( @payload[:username], @payload[:password] )
      session.destroy
      expect( session.token ).to eq( nil )

    end

  end

end




