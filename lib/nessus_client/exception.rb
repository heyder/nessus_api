class NessusClient
  # Abstract Error class for NessusClient.
  class Error < ::StandardError
    # Raise a custom error namespace.
    # @param [String] msg (message) The exception message.
    # @example
    #   NessusClient::Error.new('This is a custom error.')
    def initialize(msg="message")
      super
    end
  end
end