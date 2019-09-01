require_relative 'nessus_client/version'
require_relative 'nessus_client/exception'
require_relative 'nessus_client/resource'

Dir[File.join(__dir__, 'modules', '*.rb')].each { |file| require file }

# Nessus resource abstraction.
class NessusClient

  # @return [NessusClient::Request] Instance HTTP request object.
  # @see NessusClient::Request
  attr_reader :request
  # @return [Boolean] whether has a session.
  attr_reader :session
  # @return [Hash] Instance current HTTP headers.
  attr_reader :headers
  
  include Resource::Exports
  include Resource::Folders
  include Resource::Policies
  include Resource::Scans
  include Resource::Server
  include Resource::Session
  include Resource::Tokens

  autoload :Request, "nessus_client/request"

  # @param [Hash] params the options to create a NessusClient with.
  # @option params [String] :uri ('https://localhost:8834/') Nessus resource to connect with
  # @option params [String] :username (nil) Username to use in the connection
  # @option params [String] :password (nil) Password  to use in the connection
  # @option params [String] :ssl_verify_peer (true)  Whether should check valid SSL certificate
  def initialize( params={} )
    
    default_params = { 
      uri: 'https://localhost:8834/', 
      username: nil, 
      password: nil, 
      ssl_verify_peer: true
    }
    params = default_params.merge( params )
    req_params = params.select { |key, value| [:uri, :ssl_verify_peer].include?(key) } 

    @request = NessusClient::Request.new( req_params )
    @headers = NessusClient::Request::DEFAULT_HEADERS.dup
    self.set_session( params.fetch(:username), params.fetch(:password) )

  end

  # Gets NessusClient::Session authentication status.
  # @return [Boolean] whether NessusClient has successfully authenticated.
  def has_session?
    self.session
  end

end