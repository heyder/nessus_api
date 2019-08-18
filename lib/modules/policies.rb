# require_relative '../nessus_client/request'

module NessusClient::Policies
  def policies
    self.request.get( "/policies" )
  end
end
