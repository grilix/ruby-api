require 'jwt'

module Middleware
  class RackJWT
    BEARER_SIZE = 'Bearer '.size

    def initialize(app, opts = {})
      @app = app
      @secret = opts.fetch(:secret, nil)
    end

    def call(env)
      value = env['HTTP_AUTHORIZATION']

      return @app.call(env) unless value && value.size > 5

      token = token_from_authorization(value)

      return with_invalid_token(env) unless token

      with_token(env, token)
    end

    private

    def token_from_authorization(value)
      return if value[0...BEARER_SIZE] != 'Bearer '

      value[BEARER_SIZE...value.size]
    end

    def with_invalid_token(env)
      env = env.merge({
        'jwt.present' => true,
        'jwt.valid' => false,
      })

      @app.call(env)
    end

    def with_token(env, token)
      decoded = JWT.decode(token, @secret, true, { algorithm: 'HS256' })

      env = env.merge({
        'jwt.valid' => true,
        'jwt.present' => true,
        'jwt.payload' => decoded.first,
        'jwt.header' => decoded.last,
      })

      @app.call(env)
    end
  end
end
