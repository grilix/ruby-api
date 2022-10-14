require 'cuba'
require 'json'

require './services/users/authentication'
require './services/users/tokens'

require_relative 'forms/authenticate'

module Routes
  class Auth < Cuba
    define do
      on get, 'me' do
        payload = require_jwt!

        token = Services::Users::Tokens.refresh_token(payload)
        user = Services::Users::Tokens.user_from_token(payload)

        success!(token, { user: user })
      end

      on post, 'login' do
        form = Forms::Authenticate.from_request_body(req.body)

        unless form.valid?
          unprocessable_entity!(form.errors)
        end

        user = Services::Users::Authentication.authenticate(
          form.username,
          form.password,
        )

        unless user
          unprocessable_entity!({
            username: ['invalid'],
            password: ['invalid'],
          })
        end

        token = Services::Users::Tokens.token_from_user(user)

        success!(token, { user: user })
      end
    end
  end
end
