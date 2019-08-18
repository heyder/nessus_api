# require 'pry'
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

  def initialize( params={uri: nil, username: nil, password: nil, :ssl_verify_peer => false} )
    @has_session = false
    req_params = params.select {|key, value| [:uri, :ssl_verify_peer].include?(key) } 
    # session_params = params.select {|key, value| [:username, :password].include?(key) } 

    @request = NessusClient::Request.new( req_params )
    @session = NessusClient::Session.create( params.fetch(:username), params.fetch(:password) )
    
    if @session.token
      begin
        @has_session = true
        # NessusClient::Request.headers.update( 'X-Cookie' => 'token=' + api_session.token )
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

  def has_session?
    @has_session
  end

  def status
    self.request.get( "/server/status" )
  end

end