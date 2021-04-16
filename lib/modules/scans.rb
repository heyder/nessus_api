# frozen_string_literal: true

# Namespace for Scans resource.
module Resource::Scans
  # List scans from the resource.
  # @param [String] folder_id (nil) The name of a alredy created scan.
  # @return [JSON]
  def list_scans(folder_id = nil)
    query = folder_id.nil? ? nil : { 'folder_id' => folder_id }
    request.get({ path: '/scans', query: query, headers: headers })
  end
  alias scans list_scans

  # See details of a scan.
  # @param [String] scan_id The `uuid` of a scan.
  # @param [String] history_id (nil) The `history_id` of a scan.
  # @return [JSON]
  def scan_details(scan_id, history_id = nil)
    query = history_id.nil? ? nil : { 'history_id' => history_id }
    request.get({ path: "/scans/#{scan_id}", query: query, headers: headers })
  end

  # Lauch a scan by its id
  # @param [Integer] scan_id The ID of a alredy created scan.
  # @param [Array<String>] targets comma separeted new target to be scanned.
  # @return [JSON]
  def launch(scan_id, targets = [])
    payload = { alt_targets: targets } unless targets.empty?
    request.post({ path: "/scans/#{scan_id}/launch", payload: payload, headers: headers })
  end

  # Lauch a scan by its name
  # @param [String] scan_name The name of a alredy created scan.
  # @param [Array<String>] targets comma separeted new target to be scanned.
  # @return [JSON]
  def launch_by_name(scan_name, targets = [])
    scan_id = get_scan_by_name(scan_name)['id']
    launch(scan_id, targets)
  end

  # Get a scan by its name
  # @param [String] folder_id The id of the folder to look into.
  # @param [String] scan_name The name of the scan to look for.
  # @return [String, nil] The uuid of the scan.
  def get_scan_by_name(scan_name, folder_id = nil)
    scans = list_scans(folder_id)['scans']
    return [] if scans.nil?
    return scans.detect { |scan| scan['name'] == scan_name}
  end

  def import_scan(raw, filename)
    fileuploaded = add_attach_raw(raw, filename)["fileuploaded"]
    payload = {"file":fileuploaded}
    request.post({ path: "/scans/import", payload: payload, headers: headers })
  end

  def create_scan(payload)
    # payload = { alt_targets: targets } unless targets.empty?
    
    request.post({ path: "/scans", payload: payload, headers: headers })
  end

end
