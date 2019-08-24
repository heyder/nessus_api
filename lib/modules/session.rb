module Endpoint::Session # Namespace for Session endpoint.

  # @return [Boolean] whether has a session.
  attr_reader :session

  @session = false

  # Autenticate into Nessus endpoint.
  # @param [String] username
  # @param [String] password
  # @return [nil]
  # @raise [NessusClient::Error] Unable to authenticate.
  # @todo Validate response token format
  def set_session( username, password )
    
    payload = {
      username: username,
      password: password
    }

    resp = self.request.post( {path: '/session', payload: payload, headers: self.headers} )
    resp.match(%r{(?<token>[a-z0-9]{48})})

    raise NessusClient::Error.new( "Unable to authenticate. The response did not include a session token." ) unless $1
    
    begin
      self.headers.update( 'X-Cookie' => 'token=' + $1 )
      @session = true
      self.headers.update( 'X-API-Token' => set_api_token() ) 
    rescue NessusClient::Error => err
      puts err.message
    ensure
      return
    end
  
  end
  alias_method :session_create, :set_session

   # Destroy the current session from Nessus endpoint
   def destroy
    self.request.delete( {path: '/session', headers: self.headers} )
    @session = false
  end
  alias_method :logout , :destroy

  private

  # Set the API Token from legacy Nessus version
  # @raise [NessusClient::Error] Unable to get API Token.
  # @todo To get it direct from the session authentication on v6.x
  def set_api_token
    response = self.request.get( {path: "/nessus6.js", headers: self.headers} )
    response.match( %r{return"(\w{8}-(?:\w{4}-){3}\w{12})"\}} )
    
    raise NessusClient::Error.new( "Unable to get API Token. Some features won't work." ) unless $1
    
    return $1 
    
  end

end
