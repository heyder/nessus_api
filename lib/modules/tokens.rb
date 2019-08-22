module Endpoint::Tokens # Namespace for tokens endpoint.

  # Check the status of a export request
  # @param [String] export_uuid The export uuid string.
  # @return [JSON] 
  # @example Checking the status of a export.
  #   export_status = nc.export_status( "73376c41-1508-46b7-8587-483d159cd956" )
  #   return true if export_status["status"] == "ready"
  def token_status( export_uuid )
    self.request.get( {:path => "/tokens/#{export_uuid}/status", :headers => self.headers} )
  end

  # Check the download of a export request
  # @param [String] export_uuid The export uuid string.
  # @return [JSON] (@see #format)
  # @example Download a ready export.
  #   export = nc.export_download( '73376c41-1508-46b7-8587-483d159cd956')
  #   open("scan_report", "wb") do |file|
  #     file.write( export )
  #   end
  def token_download( export_uuid )
    self.request.get( {:path => "/tokens/#{export_uuid}/download", :headers => self.headers} )
  end

end