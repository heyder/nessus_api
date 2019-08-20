module NessusClient::Policies
  # List the scan polices from the endpoint.
  # @return [JSON]
  def policies
    self.request.get( {:path => "/policies", :headers => self.headers} )
  end
end
