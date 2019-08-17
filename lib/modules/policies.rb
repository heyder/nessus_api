# require_relative '../nessus_api/request'

module NessusApi::Policies
  def policies
    self.request.get( "/policies" )
  end
end
