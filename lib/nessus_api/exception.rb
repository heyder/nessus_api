class NessusApi
  class Error < ::StandardError
    def initialize(msg="message")
      super
    end
  end
end