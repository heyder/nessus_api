# frozen_string_literal: true

# Namespace for Exports resource.
module Resource::Exports
  # Export the given scan. Once requested, the file can be downloaded using the Resource::Tokens.token_download method upon receiving a "ready" status from the Resource::Tokens#token_status method. You can also use the older Resource::Exports#export_status and Resource::Exports#export_download methods.
  # @param [String] scan_id The export uuid string.
  # @param [String] format The file format to use (Nessus, HTML, PDF, CSV, or DB).
  # @return [JSON]
  def export_request(scan_id, format = 'nessus')
    payload = { format: format }
    request.post({ path: "/scans/#{scan_id}/export", payload: payload, headers: headers })
  end

  # Check the file status of an exported scan. When an export has been requested, it is necessary to poll this resource until a "ready" status is returned, at which point the file is complete and can be downloaded using the export download resource.
  # @param [String] scan_id The identifier for the scan. This identifier can be the either the 'schedule_uuid' or the numeric 'id' attribute for the scan. We recommend that you use 'schedule_uuid'.
  # @param [String] file_id The ID of the file to poll (Included in response from #export_request).
  # @return [JSON]
  # @example Checking the status of a export.
  #   export_status = nc.export_status( "15", "cd956" )
  #   return true if export_status["status"] == "ready"
  def export_status(scan_id, file_id)
    request.get({ path: "/scans/#{scan_id}/export/#{file_id}/status", headers: headers })
  end

  # Download exported scan.
  # @param [String] scan_id The identifier for the scan. This identifier can be the either the 'schedule_uuid' or the numeric 'id' attribute for the scan. We recommend that you use 'schedule_uuid'.
  # @param [String] file_id The ID of the file to poll (Included in response from #export_request).
  # @return [JSON]
  # @example Download a ready export.
  #   export = nc.export_download( '17', '46b78587')
  #   open("scan_report", "wb") do |file|
  #     file.write( export )
  #   end
  def export_download(scan_id, file_id)
    request.get({ path: "/scans/#{scan_id}/export/#{file_id}/download", headers: headers })
  end
end
