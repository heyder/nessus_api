# frozen_string_literal: true

# Namespace for Policies resource.
module Resource::Policies
  # List the scan polices.
  # @return [JSON]
  def policies
    request.get({ path: '/policies', headers: headers })
  end
end
