module Resource::Policies # Namespace for Policies resource.
  # List the scan polices.
  # @return [JSON]
  def policies
    self.request.get( {:path => "/policies", :headers => self.headers} )
  end
end
