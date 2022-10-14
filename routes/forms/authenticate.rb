require_relative 'base'

module Routes
  module Forms
    class Authenticate < Base
      attr_accessor :username, :password

      def validate
        assert_present :username
        assert_present :password
      end
    end
  end
end
