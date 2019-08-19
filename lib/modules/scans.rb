
module NessusClient::Scans

  # List scans from the endpoint.
  # @param [String] folder_id (nil) The name of a alredy created scan.
  # @return [JSON]
  def list_scans( folder_id=nil )
    query = folder_id.nil? ? nil : { "folder_id" => folder_id }
    self.request.get( "/scans", nil, query )
  end
  alias_method :scans, :list_scans 

  # See details of a scan.
  # @param [String] scan_id The `uuid` of a scan.
  # @param [String] history_id (nil) The `history_id` of a scan.
  # @return [JSON]
  def scan_details( scan_id, history_id=nil )
    query = history_id.nil? ? nil : { "history_id" => history_id }
    self.request.get( "/scans/#{scan_id}", nil, query )
  end

  # Lauch a scan by its id
  # @param [Integer] scan_id The ID of a alredy created scan.
  # @param [Array<String>] targets comma separeted new target to be scanned.
  # @return [JSON]
  def launch( scan_id, targets=[])
    params = { :alt_targets => targets } unless targets.empty?
    self.request.post( "/scans/#{scan_id}/launch", params )
  end

  # Lauch a scan by its name
  # @param [String] scan_name The name of a alredy created scan.
  # @param [Array<String>] targets comma separeted new target to be scanned.
  # @return [JSON]
  def launch_by_name( scan_name, targets=[] )
    scan_id = get_scan_by_name( scan_name )
    launch( scan_id, targets )   
  end

  # Get a scan by its name
  # @param [String] folder_id The id of the folder to look into.
  # @param [String] scan_name The name of the scan to look for.
  # @return [String, nil] The uuid of the scan.
  def get_scan_by_name( folder_id=nil, scan_name )
    Oj.load(list_scans( folder_id ))["scans"].each do |scan|
      return scan['id'] if scan['name'] == scan_name
    end
  end
  
end