require_relative '../nessus_api/request'

module NessusApi::Policies
  def policies
    NessusApi::Request.get( "/policies" )
  end
end
