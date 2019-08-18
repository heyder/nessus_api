class NessusClient
  class Error < ::StandardError
    def initialize(msg="message")
      super
    end
  end
end