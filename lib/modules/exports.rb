# require_relative '../nessus_client/request'

module NessusClient::Exports

  # Reques a export of vulnerabilities scan.
  # @param [String] scan_id The export uuid string.
  # @param [String] format The export format.This
  #   can be `nessus` or `nessus_db`.
  # @return [JSON]  
  def export_request( scan_id, format )
    params = {:format => format }
    self.request.post( "/scans/#{scan_id}/export", params )
  end

  # Check the status of a export request
  # @param [String] export_id The export uuid string.
  # @return [JSON] 
  # @example Checking the status of a export.
  #   export_status = nc.export_status( "73376c41-1508-46b7-8587-483d159cd956" )
  #   return true if export_status["status"] == "ready"
  def export_status( export_id )
    self.request.get( "/tokens/#{export_id}/status" )
  end

  # Download a vulnerabities scan output.
  # @param [String] export_id The export uuid string.
  # @return (see #format)
  # @example Download a ready export.
  #   export = nc.export_download("73376c41-1508-46b7-8587-483d159cd956")
  #   open("scan_report", "wb") do |file|
  #     file.write( export )
  #   end
  def export_download( export_id )
    self.request.get( "/tokens/#{export_id}/download" )
  end

end