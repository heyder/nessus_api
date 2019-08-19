
# Abstract Session class for NessusClient. 
# @since 0.1.0
# @attr_reader [String] token Autentication session token.
# @attr_reader [String] api_token Autentication API token.
module NessusClient::Session

  attr_reader :session #, :token, :api_token

  @@api_token = @session = nil

  # Autenticate into Nessus endpoint.
  # @param [String] username
  # @param [String] password
  # @return [nil]
  # @raise [NessusClient::Error] Unable to authenticate.
  # @todo Validate response token format
  def set_session( username, password )
    
    payload = {
      username: username,
      password: password,
    }

    response = self.request.post( '/session', payload=payload, headers=self.headers )
    response = Oj.load(response) if response.length > 0

    raise NessusClient::Error.new( "Unable to authenticate. The response did not include a session token." ) unless response['token']

    begin
      self.headers.update( 'X-Cookie' => 'token=' + response['token'] )
      @session = true
      self.headers.update( 'X-API-Token' => set_api_token() ) 
    rescue NessusClient::Error => err
      puts err.message
    else
      @@api_token = true
    ensure
      return
    end
  
  end
  alias_method :session_create, :set_session

   # Destroy the current session from Nessus endpoint
   def destroy
    self.request.delete( '/session', nil, self.headers )
    @token = nil
  end
  alias_method :logout , :destroy

  private

  # Set the API Token from legacy Nessus version
  # @raise [NessusClient::Error] Unable to get API Token.
  def set_api_token
    response = self.request.get( "/nessus6.js", headers=self.headers )
    response.match( %r{return"(\w{8}-(?:\w{4}-){3}\w{12})"\}} )
    
    raise NessusClient::Error.new( "Unable to get API Token. Some features won't work." ) unless $1
    
    return $1 
    
  end

end
