
require_relative 'nessus_api/version'

Dir[File.join(__dir__, 'modules', '*.rb')].each { |file| require file }

class NessusApi
  
  include NessusApi::Scans
  include NessusApi::Exports
  include NessusApi::Folders
  include NessusApi::Policies

  autoload :Request, "nessus_api/request"
  autoload :Session, "nessus_api/session"

  def initialize( params={uri: nil, username: nil, password: nil, :ssl_verify_peer => false} )

    req_params = params.select {|key, value| [:uri, :ssl_verify_peer].include?(key) } 
    # session_params = params.select {|key, value| [:username, :password].include?(key) } 

    @@request = NessusApi::Request.new( req_params )
    api_session = NessusApi::Session.create( params.fetch(:username), params.fetch(:password) )
    
    if api_session.token
      @has_session = true
      NessusApi::Request.headers.update( 'X-Cookie' => 'token=' + api_session.token )
    end

    if has_session?
      api_session.get_api_token
      NessusApi::Request.headers.update( 'X-API-Token' => api_session.api_token )
    end

  end

  def has_session?
    @has_session
  end

  def status
    NessusApi::Request.get( "/server/status" )
  end

end