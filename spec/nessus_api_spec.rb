

require_relative 'spec_helper'

describe NessusApi do
  it 'has a version number' do
    expect(NessusApi::VERSION).not_to be nil
  end

  context "status" do
    it "is ready" do
      # allow( NessusApi::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusApi::Session.new('lhebs') )/
      # NessusApi::Request.new({ :uri => 'http://ness.us' })
      payload = {
        uri: 'http://ness.us',
        username: 'username',
        password: 'password'
      }
      # allow( NessusApi::Request ).to receive( :get ).with( '/server/status').and_return( {:status => 'ready'}.to_json )
      allow( NessusApi::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusApi::Session.new( 'token' ) )
      nessus_api = NessusApi.new( payload )
      allow_any_instance_of( NessusApi ).to receive( :status ).and_return( nessus_api ) 
      # expect( Oj.load( @nessus.status )['status'] ).to eql 'ready'
    end
  end
end

