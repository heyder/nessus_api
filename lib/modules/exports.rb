# require_relative '../nessus_api/request'

module NessusApi::Exports
 # export scans
  def export_request( scan_id, format )
    params = {:format => format }
    self.request.post("/scans/#{scan_id}/export", params)
  end
  def export_status( export_id )
    self.request.get("/tokens/#{export_id}/status")
  end
  def export_download( export_id )
    self.request.get("/tokens/#{export_id}/download")
  end
end