# frozen_string_literal: true

# Namespace for Server resource.
module Resource::Server
  # Returns the server status.
  # @return [Hash] Returns the server status
  def server_status
    request.get({ path: '/server/status', headers: headers })
  end

  # Returns the server version and other properties.
  # @return [Hash] Returns the server properties
  def server_properties
    request.get({ path: '/server/properties', headers: headers })
  end
end
