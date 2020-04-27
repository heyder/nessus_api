module Resource::Server # Namespace for Server resource.
  # Returns the server status.
  # @return [JSON] Returns the server status (loading, ready, corrupt-db, feed-expired, eval-expired, locked, register, register-locked, download-failed, feed-error).
  def server_status
    self.request.get({ :path => "/server/status", :headers => self.headers })
  end

  # Returns the server version and other properties.
  # @return [JSON] Returns the server properties
  def server_properties
    self.request.get({ :path => "/server/properties", :headers => self.headers })
  end
end
