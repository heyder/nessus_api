require_relative '../nessus_api/request'

module NessusApi::Folders
# folders
  def list_folders
    NessusApi::Request.get("folders")
  end
  def create_folder( folder_name )
    params = {:name => folder_name }.to_json
    NessusApi::Request.post("folders", params)
  end
end