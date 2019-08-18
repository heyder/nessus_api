require 'oj'
require_relative 'request'
require_relative 'exception'

class NessusClient

  # This class should be used to get an access token
  # for use with the main client class.
  class Session
    attr_reader :token, :api_token

    @token = @api_token  = nil

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

    def initialize( token )      
      @token = token
    end

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
