require 'excon'
require 'json'

class NessusClient

  # Abstract request class for NessusClient. Provides some helper methods for
  class Request

    attr_reader :url

    # Default HTTP header to be used on the requests.
    DEFAULT_HEADERS = {
      "User-Agent" => "Mozilla/5.0 (Linux x86_64)",
      "Content-Type" => "application/json"
    }.freeze

    def initialize( params )
      # @headers = params[:headers] ||  DEFAULT_HEADERS 
      params = {:uri => nil }.merge( params )
      @@ssl_verify_peer = params[:ssl_verify_peer] ? true : false
      @url = @@url = NessusClient::Request.uri_parse( params.fetch(:uri) )
    end

    # @raise [NotImplementedError] Use update from Hash insted.
    # def headers=(value)
    #   raise NotImplementedError.new("Use update from Hash insted.")
    # end

    # Perform a HTTP GET to the endpoint.
    # @param [String] path The URI path to perform the request.
    # @param [String] payload The HTTP body to send.
    # @param [String] query The URI query to send.
    def get( path=nil, payload=nil, query=nil, headers=nil )
      http_request( :get, path, payload, query, headers )
    end

    # Perform a HTTP POST to the endpoint.
    # @param [String] path The URI path to perform the request.
    # @param [String] payload The HTTP body to send.
    # @param [String] query The URI query to send.
    def post( path=nil, payload=nil, query=nil, headers=nil )
      http_request( :post, path, payload, query, headers )
    end

    # Perform a HTTP DELETE to the endpoint.
    # @param [String] path The URI path to perform the request.
    # @param [String] payload The HTTP body to send.
    # @param [String] query The URI query to send.
    def delete( path=nil, payload=nil, query=nil, headers=nil )
      http_request( :delete, path, payload, query, headers )
    end
    # Parse a receiveid URI
    # @param [String] uri A valid URI.
    # @return [String] A string uri.
    def self.uri_parse( uri )
      url = URI.parse( uri )
      raise URI::InvalidURIError unless url.scheme
      return url.to_s
    end

    private

    # @private HTTP request abstraction to be used.
    # @param [Symbol] method A HTTP method to be used could be `:get`, `:post` or `:delete`.
    # @param [String] path The URI path to perform the request.
    # @param [String] payload The HTTP body to send.
    # @param [String] query The URI query to send.
    def http_request( method=:get, path, payload, query, headers )
      connection = Excon.new( @@url, {ssl_verify_peer: @@ssl_verify_peer} )
      
      body = payload ? payload.to_json : ''
      options = {
        method: method,
        path: path,
        body: body,
        query: query,
        headers: headers,
        expects: [200, 201]
      }
      response = connection.request( options )
    
      return response.body if response.body.length > 0

    end

  end
  
end
