require 'oj'
require_relative 'request'
require_relative 'exception'

class NessusClient

  # Abstract base class for NessusClient Session. 
  # @since 0.1.0
  # @attr_reader [String] token Autentication session token.
  # @attr_reader [String] api_token Autentication API token.
  class Session
    attr_reader :token, :api_token

    @token = @api_token  = nil

    # Autenticate into Nessus endpoint.
    # @param [String] username
    # @param [String] password
    # @raise [NessusClient::Error] Unable to authenticate.
    def self.create( username, password )
      
      payload = {
        username: username,
        password: password,
      }

      response = self.request.post( '/session', payload )
      response = Oj.load(response) if response.length > 0

      if response['token']
         return self.new( response['token'] )
      else
        raise NessusClient::Error.new( "Unable to authenticate. The response did not include a session token." )
      end

    end

    # Initialize a NessusClient::Session instance
    # @param [String] token Authentication token string. 
    # @return [NessusClient::Session]
    def initialize( token )      
      @token = token
    end

    # Set the API Token from legacy Nessus version
    # @raise [NessusClient::Error] Unable to get API Token.
    def set_api_token
      response = self.request.get( "/nessus6.js" )
      response.match( %r{return"(\w{8}-(?:\w{4}-){3}\w{12})"\}} )
      
      raise NessusClient::Error.new( "Unable to get API Token. Some features won't work." ) unless $1#.nil?
      
      @api_token = $1 
      
    end

    # Destroy the current session from Nessus endpoint
    def destroy
      self.request.delete( '/session', nil )
      @token = nil
    end
    alias_method :logout , :destroy

  end

end
