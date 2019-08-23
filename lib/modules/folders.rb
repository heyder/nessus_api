module Endpoint::Folders # Namespace for Folders endpoint.
  # Get the list of folders from the endpoint.
  # @return [JSON]
  def list_folders
    self.request.get({:path => "/folders", :headers => self.headers})
  end
  # Create a folder into the endpoint.
  # @param [String] folder_name The name of the folder the will be created.
  # @return [JSON]
  def create_folder( folder_name )
    payload = {:name => folder_name }
    self.request.post({:path=>"/folders", :payload => payload, :headers => self.headers})
  end
end