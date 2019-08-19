module NessusClient::Exports

  # Request a export of vulnerabilities scan.
  # @param [String] scan_id The export uuid string.
  # @param [String] format The file format to use (Nessus, HTML, PDF, CSV, or DB).
  # @return [JSON]  
  def export_request( scan_id, format="nessus" )
    params = {:format => format }
    self.request.post( "/scans/#{scan_id}/export", params, headers=self.headers )
  end

  # Check the status of a export request
  # @param [String] export_id The export uuid string.
  # @return [JSON] 
  # @example Checking the status of a export.
  #   export_status = nc.export_status( "73376c41-1508-46b7-8587-483d159cd956" )
  #   return true if export_status["status"] == "ready"
  def export_status( export_id )
    self.request.get( "/tokens/#{export_id}/status", headers=self.headers )
  end

  # Download a vulnerabities scan output.
  # @param [Integer] scan_id The id of the scan to export.
  # @param [Integer] file_id The id of the file to download (see #export_request).
  # @return (see #format)
  # @example Download a ready export.
  #   export = nc.export_download("73376c41-1508-46b7-8587-483d159cd956")
  #   open("scan_report", "wb") do |file|
  #     file.write( export )
  #   end
  def export_download( scan_id, file_id )
    self.request.get( "/scans/#{scan_id}/export/#{file_id}/download", headers=self.headers )
  end

end