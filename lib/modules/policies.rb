# frozen_string_literal: true

# Namespace for Policies resource.
module Resource::Policies
  # List the scan polices.
  # @return [Hash] list of policies.
  def policies
    request.get({ path: '/policies', headers: headers })
  end
  # Get id of a policy by its name.
  # @param [String] policy_name The of the policy.
  # @return [Integer] ID of a policy.

  def get_policy_id_by_name(policy_name)
    policies['policies'].each do |policy|
      return policy['id'] if policy['name'] == policy_name
    end
  end

  # Get a policy by its name.
  # @param [String] policy_name The of the policy.
  # @return [Hash] A policy object.
  def get_policy_by_name(policy_name)
    policy_id = get_policy_id_by_name(policy_name)
    request.get({ path: "/policies/#{policy_id}", headers: headers })
  end

  # Get a list of credentials from a policy.
  # @param [String] policy_name The of the policy.
  # @return [Hash] List of credentials
  def list_credentials_by_policy_name(policy_name)
    get_policy_by_name(policy_name)['credentials']
  end

  # update a scan policy.
  # @param [String] policy_name The policy name.
  # @param [Hash]  The policy fields to be updated.
  # @return nil
  def update_policy_by_name(policy_name, settings)
    id = get_policy_id_by_name(policy_name)
    request.put({ path: "/policies/#{id}", headers: headers, payload: settings })
  end

  def add_attach_raw(raw, filename, path)
    c = Curl::Easy.new("#{self.request.url}/#{path}")
    c.ssl_verify_peer = false
    c.ssl_verify_host = 0
    c.headers = self.headers.clone
    c.headers.update({ "Content-Type" => "multipart/form-data"})
    c.multipart_form_post = true
    post_field = Curl::PostField.content('Filedata', raw)
    post_field.remote_file = filename
    c.http_post(post_field)
    pp c.body
    return Oj.load(c.body)
  end

  def import_policy(raw, filename, path)
    fileuploaded = add_attach_raw(raw, filename, path)["fileuploaded"]
    payload = {"file":fileuploaded}
    request.post({ path: "/policies/import", payload: payload, headers: headers })
  end
end
