# require_relative '../nessus_client/request'

module NessusClient::Folders
# folders
  def list_folders
    self.request.get("/folders")
  end
  def create_folder( folder_name )
    params = {:name => folder_name }.to_json
    self.request.post("/folders", params)
  end
end