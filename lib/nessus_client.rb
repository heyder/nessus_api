require_relative 'nessus_client/version'
require_relative 'nessus_client/exception'

Dir[File.join(__dir__, 'modules', '*.rb')].each { |file| require file }

class NessusClient

  attr_reader :request, :session
  
  include NessusClient::Scans
  include NessusClient::Exports
  include NessusClient::Folders
  include NessusClient::Policies

  autoload :Request, "nessus_client/request"
  autoload :Session, "nessus_client/session"

  # @param [Hash] params the options to create a NessusClient with.
  # @option params [String] :uri ('https://localhost:8834/') Nessus endpoint to connect with
  # @option params [String] :username Username (nil) to use in the connection
  # @option params [String] :password Password (nil) to use in the connection
  # @option params [String] :ssl_verify_peer (false) should check whether valid SSL certificate
  def initialize( params = {} )
    @has_session = false
    default_params = {uri: 'https://localhost:8834/', username: nil, password: nil, :ssl_verify_peer => false}
    params = default_params.merge( default_params )
    req_params = params.select {|key, value| [:uri, :ssl_verify_peer].include?(key) } 

    @request = NessusClient::Request.new( req_params )
    @session = NessusClient::Session.create( params.fetch(:username), params.fetch(:password) )
    
    if @session.token
      begin
        @has_session = true
        @request.headers.update( 'X-Cookie' => 'token=' + @session.token )
        @session.set_api_token
      rescue NessusClient::Error => err
        puts err.message
      else
        request.headers.update( 'X-API-Token' => @session.api_token )
      ensure
        return
      end

    end

  end

  # Gets NessusClient::Session authentication status.
  # @return [Boolean]
  def has_session?
    @has_session
  end

  # Gets the server status.
  # @return [Json] Returns the server status (loading, ready, corrupt-db, feed-expired, eval-expired, locked, register, register-locked, download-failed, feed-error).
  def status
    self.request.get( "/server/status" )
  end

end