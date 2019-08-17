require_relative '../spec_helper'

describe NessusApi::Session do

  before(:context) do
    RSpec::Mocks.with_temporary_scope do
      payload = {
        :username => 'username',
        :password => 'password'
      }
      allow( NessusApi::Request ).to receive( :post ).with( '/session', payload ).and_return( {'token' => 'token_test' }.to_json )
      @nessus_session = NessusApi::Session.create( payload[:username], payload[:password] )  
    end
  end

  context "initialize" do

    it "session has been created" do
      expect( @nessus_session ).to be_instance_of NessusApi::Session
    end

    it "has a token" do
      expect( @nessus_session.token.nil?).to eql false
    end

    it "expect token string value" do
      expect( @nessus_session.token ).to eq ('token_test')
    end

    it "has NOT session token" do
      payload = {
        username: 'username',
        password: 'password',
      }
      allow( NessusApi::Request ).to receive( :post ).with( '/session', payload ).and_return( {}.to_json )
      expect{ NessusApi::Session.create( payload[:username], payload[:password] ) }.to raise_error( NessusApi::Error )
    end

  end

  context ".get_api_token" do

    it "should match valid api token" do
      NessusApi::Request.new({ :uri => 'http://ness.us' })
      allow( NessusApi::Request ).to receive( :get ).with( '/nessus6.js').and_return( 'return"0000000A-0AAA-A000-A111-A11111111111"}' )
      allow( NessusApi::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusApi::Session.new('lhebs') )
      
      payload = {
        username: 'username',
        password: 'password',
      }
      session = NessusApi::Session.create( payload[:username], payload[:password] ) 
      session.get_api_token
      expect( session.api_token ).to eq( '0000000A-0AAA-A000-A111-A11111111111' )
    end

    it "didn't match api token, shoud raise NessusApi::Error [Unable to get API Token. Some features wont work.]" do
      NessusApi::Request.new({ :uri => 'http://ness.us' })
      allow( NessusApi::Request ).to receive( :get ).with( '/nessus6.js').and_return( 'this_sring_doesnt_match_the_token' )
      allow( NessusApi::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusApi::Session.new('lhebs') )
      
      payload = {
        username: 'username',
        password: 'password',
      }
      session = NessusApi::Session.create( payload[:username], payload[:password] ) 
      expect{ session.get_api_token }.to raise_error( NessusApi::Error )
      expect( session.api_token ).to eq( nil )
    end

  end
  
  context ".delete" do

    it "token should be nil after logout" do
      NessusApi::Request.new({ :uri => 'http://ness.us' })
      allow( NessusApi::Request ).to receive( :delete ).with( '/session', nil).and_return('')
      allow( NessusApi::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusApi::Session.new('lhebs') )
      
      payload = {
        username: 'username',
        password: 'password',
      }
      session = NessusApi::Session.create( payload[:username], payload[:password] )
      session.destroy
      expect( session.token ).to eq( nil )

    end

  end

end




