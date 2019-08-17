require 'excon'
require 'json'
# require 'pry'
class NessusApi

  # Excon.defaults[:ssl_verify_peer] = false
  # This class should be used to in all requests classes
  
  class Request
    # attr_accessor :headers
    attr_reader   :url

    @headers = {
      "User-Agent" => "Mozilla/5.0 (Linux x86_64)",
      "Content-Type" => "application/json"
    }

    def initialize( params )
      params = {:uri => nil, :ssl_verify_peer => false}.merge( params )
      @@ssl_verify_peer = params.fetch(:ssl_verify_peer)
      @url = @@url = NessusApi::Request.uri_parse( params.fetch(:uri) )
    end

    def self.headers
      @headers
    end
 
    def self.get( path=nil, payload=nil, query=nil )
      http_request( :get, path, payload, query )
    end

    def self.post( path=nil, payload=nil, query=nil )
      http_request( :post, path, payload, query )
    end

    def self.delete( path=nil, payload=nil, query=nil )
      http_request( :delete, path, payload, query )
    end

    def self.uri_parse( uri )
      url = URI.parse( uri )
      raise URI::InvalidURIError unless url.scheme
      return url.to_s
    end

    private

    def self.http_request( method=:get, path, payload, query )
      # binding.pry
      connection = Excon.new( @@url )
      
      body = payload ? payload.to_json : ''
      options = {
        method: method,
        path: path,
        body: body,
        query: query,
        headers: @headers,
        ssl_verify_peer: @@ssl_verify_peer,
        #idempotent: true,
        #proxy: "http://127.0.0.1:8080",
        expects: [200, 201]
      }
      response = connection.request(options)
    
      return response.body if response.body.length > 0

    end

  end
  
end
