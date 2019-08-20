module NessusClient::Policies # Namespace for Policies endpoint.
  # List the scan polices.
  # @return [JSON]
  def policies
    self.request.get( {:path => "/policies", :headers => self.headers} )
  end
end
