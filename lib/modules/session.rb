# frozen_string_literal: true

# Namespace for Session resource.
module Resource::Session
  # @return [Boolean] whether has a session.
  attr_reader :session

  @session = false

  # Autenticate into Nessus resource.
  # @param [String] username
  # @param [String] password
  # @return [nil]
  # @raise [NessusClient::Error] Unable to authenticate.
  # @todo Validate response token format
  def set_session(username, password)
    payload = {
      username: username,
      password: password
    }

    resp = request.post({ path: '/session', payload: payload, headers: headers })
    # binding.pry
    if !resp.key?('token')
      raise NessusClient::Error, 'Unable to authenticate.'
    elsif !resp['token'].match(/(?<token>[a-z0-9]{48})/)
      raise NessusClient::Error, 'The token doesnt match with the pattern.'
    end

    headers.update('X-Cookie' => 'token=' + resp['token'])
    @session = true
    api_token = set_api_token
    headers.update('X-API-Token' => api_token) if api_token
  rescue NessusClient::Error => e
    raise e
  end
  alias session_create set_session

  # Destroy the current session.
  def destroy
    request.delete({ path: '/session', headers: headers })
    @session = false
  end
  alias logout destroy

  private

  # Set the API Token from legacy Nessus version
  # @raise [NessusClient::Error] Unable to get API Token.
  # @todo To get it direct from the session authentication on v6.x
  def set_api_token
    response = request.get({ path: '/nessus6.js', headers: headers })
    response.match(/return"(\w{8}-(?:\w{4}-){3}\w{12})"\}/)
    unless  Regexp.last_match(1)
      raise NessusClient::Error, "Unable to get API Token. Some features won't work."
    end
  rescue NessusClient::Error => e
    puts e.message
  else
    Regexp.last_match(1)
  end
end
