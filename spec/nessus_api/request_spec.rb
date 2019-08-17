
require_relative '../spec_helper'

describe NessusApi::Request do

  before(:context) do
    @req = NessusApi::Request.new( {:uri => 'http://ness.us'} )    
  end

  context "initialize" do
    it "when valid uri" do
      expect( NessusApi::Request.new( {:uri => 'http://ness.us'} ) ).to be_instance_of( NessusApi::Request )
    end

    it "when no uri, should raise ArgumentError exception" do
      expect { NessusApi::Request.new }.to raise_error( ArgumentError )
    end

    it "when nil on into initialize, should raise TypeError exception" do
      expect { NessusApi::Request.new( nil ) }.to raise_error( TypeError )
    end

    it "when uri is nil, should raise URI::InvalidURIError exception" do
      expect { NessusApi::Request.new( {:uri => nil} ) }.to raise_error( URI::InvalidURIError )
    end
  end

  context ".url" do
    it "can NOT read from class method" do
      expect{ NessusApi::Request.url }.to raise_error( NoMethodError )
    end
    it "can NOT write from class method" do
      expect{ NessusApi::Request.url="none" }.to raise_error( NoMethodError )
    end    
    it "can read from instance method" do
      # read
      expect( @req.url ).to eq( 'http://ness.us' )
    end
    it "can write from instance method" do
      # write 
      expect{ @req.url='http://nessus.io' }.to raise_error( NoMethodError )
    end
  end

  context ".headers" do
    it "can read from class method" do
      expect( NessusApi::Request.headers ).to be_instance_of( Hash )
    end
    it "can write from class method" do
      NessusApi::Request.headers.update( {"none" => 1} )
      expect( NessusApi::Request.headers ).to have_key( "none" )
      NessusApi::Request.headers.delete( "none" )
      expect( NessusApi::Request.headers ).not_to have_key( "none" )
    end
    it "cannot read/write from instance method" do
      req = NessusApi::Request.new( { :uri => 'http://ness.us' } ) 
      # read
      expect{ req.headers }.to raise_error( NoMethodError )
      # write
      expect{ req.headers=nil }.to raise_error( NoMethodError )
    end
    it "still default" do
      # hard coded default header
      default_header = {
        "User-Agent" => "Mozilla/5.0 (Linux x86_64)",
        "Content-Type" => "application/json"
      }
      expect( NessusApi::Request.headers ).to eq( default_header )
    end

  end

  context ".get" do
    # it "response has a body" do
    #   allow( NessusApi::Request ).to receive( :get ).and_return( "RESPONSE_BODY" )
    #   expect( NessusApi::Request.get ).to eq( "RESPONSE_BODY" )
    # end
    it "default request/response" do
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_return( 
        Excon::Response.new( 
          {
            :body =>'RESPONSE_BODY',
            :status => 200
          }
        )
      )
      expect( NessusApi::Request.get ).to eq( "RESPONSE_BODY" )
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
      expect( NessusApi::Request.get('path','payload','query') ).to eq( "RESPONSE_BODY" )
    end
    it "empty response" do
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_return( Excon::Response.new({:body=>''}) )
      expect( NessusApi::Request.get ).to eq( nil )
    end
    it "should raise Excon::Error exception" do
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_raise( Excon::Error )
      expect{ NessusApi::Request.get('/') }.to raise_error( Excon::Error )
    end
    
  end

  context ".post" do

    it "request with no parameters" do
      allow( NessusApi::Request ).to receive( :post ).and_return( "RESPONSE_BODY" )
      expect( NessusApi::Request.post ).to eq( "RESPONSE_BODY" )
    end
    it "request with json data" do
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_return( Excon::Response.new({:body=>'RESPONSE_BODY'}) )
      expect( NessusApi::Request.post(nil,'{"key":"data"}',nil) ).to eq( "RESPONSE_BODY" )
    end
  end

  context ".delete" do
    it "request with no parameters" do
      allow( NessusApi::Request ).to receive( :delete ).and_return( "RESPONSE_BODY" )
      expect( NessusApi::Request.delete ).to eq( "RESPONSE_BODY" )
    end
    it "request with json data" do
      allow_any_instance_of( Excon::Connection ).to receive( :request ).and_return( Excon::Response.new({:body=>'RESPONSE_BODY'}) )
      expect( NessusApi::Request.delete(nil,'{"key":"data"}',nil) ).to eq( "RESPONSE_BODY" )
    end
  end


  


end



# describe "status" do
#   it "is ready" do
#     expect( Oj.load( @nessus.status )['status'] ).to eql 'ready'
#   end
# end

