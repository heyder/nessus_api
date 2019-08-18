require 'oj'
# require_relative 'request'
# require_relative 'exception'

# Abstract base class for NessusClient Session. 
# @since 0.1.0
# @attr_reader [String] token Autentication session token.
# @attr_reader [String] api_token Autentication API token.
module NessusClient::Session

  attr_reader :token, :api_token

  @token = @api_token  = nil

  # Autenticate into Nessus endpoint.
  # @param [String] username
  # @param [String] password
  # @raise [NessusClient::Error] Unable to authenticate.
  # @todo Validate response token format
  def set_session( username, password )
    
    payload = {
      username: username,
      password: password,
    }

    response = self.request.post( '/session', payload )
    response = Oj.load(response) if response.length > 0

    raise NessusClient::Error.new( "Unable to authenticate. The response did not include a session token." ) unless response['token']
    
    @token = response['token']
  
  end
  alias_method :session_create, :set_session

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
