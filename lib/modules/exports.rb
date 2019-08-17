require_relative '../nessus_api/request'

module NessusApi::Exports
 # export scans
  def export_request( scan_id, format )
    params = {:format => format }
    NessusApi::Request.post("/scans/#{scan_id}/export", params)
  end
  def export_status( export_id )
    NessusApi::Request.get("/tokens/#{export_id}/status")
  end
  def export_download( export_id )
    NessusApi::Request.get("/tokens/#{export_id}/download")
  end
end