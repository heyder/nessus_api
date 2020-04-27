class NessusClient
  # Abstract Error class for NessusClient.
  class Error < ::StandardError
    # Raise a custom error namespace.
    # @param [String] msg The exception message.
    # @example
    #   NessusClient::Error.new('This is a custom error.')
    def initialize(msg)
      super
    end
  end
end
