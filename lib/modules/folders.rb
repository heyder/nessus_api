# require_relative '../nessus_client/request'

module NessusClient::Folders
  # Get the list of folders from the endpoint.
  # @return [JSON]
  def list_folders
    self.request.get("/folders")
  end
  # Create a folder into the endpoint.
  # @param [String] folder_name The name of the folder the will be created.
  # @return [Json]
  def create_folder( folder_name )
    params = {:name => folder_name }.to_json
    self.request.post("/folders", params)
  end
end