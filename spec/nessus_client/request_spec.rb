
require_relative '../spec_helper'

describe NessusClient::Request do

  before(:context) do
    @nessus_request = NessusClient::Request.new( {:uri => 'http://ness.us', :ssl_verify_peer => true } )    
  end

  context "initialize" do
    it "when valid uri" do
      expect( NessusClient::Request.new( {:uri => 'http://ness.us'} ) ).to be_instance_of( NessusClient::Request )
    end

    it "when no uri, should raise URI::InvalidURIError exception. Because there is a nil as default" do
      expect { NessusClient::Request.new }.to raise_error( URI::InvalidURIError )
    end

    it "when nil on into initialize, should raise TypeError exception" do
      expect { NessusClient::Request.new( nil ) }.to raise_error( TypeError )
      expect { NessusClient::Request.new( {} ) }.to raise_error( URI::InvalidURIError )      
    end

    it "when uri is nil, should raise URI::InvalidURIError exception" do
      expect { NessusClient::Request.new( {:uri => nil} ) }.to raise_error( URI::InvalidURIError )
    end
  end

  context ".url" do
    it "can NOT read from class method" do
      expect{ NessusClient::Request.url }.to raise_error( NoMethodError )
    end
    it "can NOT write from class method" do
      expect{ NessusClient::Request.url="none" }.to raise_error( NoMethodError )
    end    
    it "can read from instance method" do
      # read
      expect( @nessus_request.url ).to eq( 'http://ness.us' )
    end
    it "can write from instance method" do
      # write 
      expect{ @nessus_request.url='http://nessus.io' }.to raise_error( NoMethodError )
    end
  end

  context ".headers" do
    it "can NOT read/write from class method" do
      expect{ NessusClient::Request.headers }.to raise_error( NoMethodError )
    end
    
    it "there in no headers in the class anymore, can NOT read/write from instance method" do
      req = NessusClient::Request.new( { :uri => 'http://ness.us' } ) 
      # read
      expect{ req.headers }.to raise_error( NoMethodError )
    end

    it "still default" do
      # hard coded default header
      default_header = {
        "User-Agent" => "Mozilla/5.0 (Linux x86_64)",
        "Content-Type" => "application/json"
      }
      expect( NessusClient::Request::DEFAULT_HEADERS ).to eq( default_header )
    end

  end

  context ".get" do
    it "response has a body" do
      allow( NessusClient::Request ).to receive( :get ).and_return( "RESPONSE_BODY" )
      expect( NessusClient::Request.get ).to eq( "RESPONSE_BODY" )
    end
    it "default request/response" do
      allow_any_instance_of( NessusClient::Request ).to receive( :get ).and_return( "RESPONSE_BODY"  )
      expect( @nessus_request.get ).to eq( "RESPONSE_BODY" )
    end

    it "all parameters defined" do
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_return( 
        Excon::Response.new( 
          {
            :body =>'RESPONSE_BODY',
            :status => 200
          }
        )
      )
      expect( @nessus_request.get({path: 'path', payload: 'payload', query: 'query'}) ).to eq( "RESPONSE_BODY" )
    end
    it "empty response" do
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_return( Excon::Response.new({:body=>''}) )
      expect( @nessus_request.get ).to eq( nil )
    end
    it "should raise Excon::Error exception" do
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_raise( Excon::Error )
      expect{ @nessus_request.get({path: '/'}) }.to raise_error( Excon::Error )
    end
    
  end

  context ".post" do

    it "request with no parameters" do
      allow_any_instance_of( NessusClient::Request ).to receive( :post ).and_return( "RESPONSE_BODY" )
      expect( @nessus_request.post ).to eq( "RESPONSE_BODY" )
    end
    it "request with json data" do
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_return( Excon::Response.new({:body=>'RESPONSE_BODY'}) )
      expect( @nessus_request.post( {path: '/', payload: '{"key":"data"}'} ) ).to eq( "RESPONSE_BODY" )
    end
  end

  context ".delete" do
    it "request with no parameters" do
      allow_any_instance_of( NessusClient::Request ).to receive( :delete ).and_return( "RESPONSE_BODY" )
      expect( @nessus_request.delete ).to eq( "RESPONSE_BODY" )
    end
    it "request with json data" do
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_return( Excon::Response.new({:body=>'RESPONSE_BODY'}) )
      expect( @nessus_request.delete({path: '/', payload: '{"key":"data"}'}) ).to eq( "RESPONSE_BODY" )
    end
  end

end
