# frozen_string_literal: true

# Namespace for Folders resource.
module Resource::Folders
  # Get the list of folders from the resource.
  # @return [Hash]
  def list_folders
    request.get({ path: '/folders', headers: headers })
  end

  # Create a folder into the resource.
  # @param [String] folder_name The name of the folder the will be created.
  # @return [Hash]
  def create_folder(folder_name)
    payload = { name: folder_name }
    request.post({ path: '/folders', payload: payload, headers: headers })
  end
end
