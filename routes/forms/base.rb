require 'scrivener'

module Routes
  module Forms
    class Base < Scrivener
      def self.from_request_body(body)
        params = JSON.parse(body.read)

        new(params)
      end
    end
  end
end
