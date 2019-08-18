require 'oj'
require_relative 'request'
require_relative 'exception'

class NessusClient

  # Abstract base class for NessusClient Session. 
  # @since 0.1.0
  # @attr_reader [String] token autentication session token
  # @attr_reader [String] api_token autentication API token
  class Session
    attr_reader :token, :api_token

    @token = @api_token  = nil

    # Create a session and get its autentication token
    # @param [String] username
    # @param [String] password
    def self.create( username, password )
      
      payload = {
        username: username,
        password: password,
      }

      response = NessusClient::Request.post( '/session', payload )
      response = Oj.load(response) if response.length > 0

      if response['token']
         return self.new( response['token'] )
      else
        raise NessusClient::Error.new "#{__method__}::Response did not include a session token."
      end

    end
    # @param [String] authentication token 
    def initialize( token )      
      @token = token
    end

    # Set the API Token from legacy Nessus version
    def set_api_token
      response = NessusClient::Request.get( "/nessus6.js" )
      response.match( %r{return"(\w{8}-(?:\w{4}-){3}\w{12})"\}} )
      
      raise NessusClient::Error.new( "Unable to get API Token. Some features won't work." ) unless $1#.nil?
      
      @api_token = $1 
      
    end

    def destroy
      NessusClient::Request.delete( '/session', nil )
      @token = nil
    end
    alias_method :logout , :destroy

  end

end
