require 'jwt'

HMAC_SECRET = ENV['HMAC_SECRET']
TOKEN_DURATION = 12 * 60 * 60 # 12 horas

module Services
  module Users
    module Tokens
      def self.user_from_token(payload)
        {
          id: payload['user_id'],
          username: payload['username'],
        }
      end

      def self.token_from_user(user)
        refresh_token({
          'user_id' => user[:id],
          'username' => user[:username],
        })
      end

      def self.refresh_token(payload)
        exp = Time.now.to_i + TOKEN_DURATION

        JWT.encode(payload.merge({
          'exp' => exp,
        }), HMAC_SECRET, 'HS256')
      end
    end
  end
end
