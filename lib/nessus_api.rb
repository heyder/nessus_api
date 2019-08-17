# require 'pry'
require_relative 'nessus_api/version'
require_relative 'nessus_api/exception'

Dir[File.join(__dir__, 'modules', '*.rb')].each { |file| require file }

class NessusApi

  attr_reader :request, :session
  
  include NessusApi::Scans
  include NessusApi::Exports
  include NessusApi::Folders
  include NessusApi::Policies

  autoload :Request, "nessus_api/request"
  autoload :Session, "nessus_api/session"

  def initialize( params={uri: nil, username: nil, password: nil, :ssl_verify_peer => false} )
    @has_session = false
    req_params = params.select {|key, value| [:uri, :ssl_verify_peer].include?(key) } 
    # session_params = params.select {|key, value| [:username, :password].include?(key) } 

    @request = NessusApi::Request.new( req_params )
    @session = NessusApi::Session.create( params.fetch(:username), params.fetch(:password) )
    
    if @session.token
      begin
        @has_session = true
        # NessusApi::Request.headers.update( 'X-Cookie' => 'token=' + api_session.token )
        @request.headers.update( 'X-Cookie' => 'token=' + @session.token )
        @session.set_api_token
      rescue NessusApi::Error => err
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