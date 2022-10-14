require 'cuba'
require 'rack/jwt'

require './routes/plugins/api'
require './routes/auth'

require './db/connect'

Cuba.use Rack::JWT::Auth, {
  secret: ENV.fetch('HMAC_SECRET'),
  verify: true,
  options: { algorithm: 'HS256' },
  exclude: [
    '/api/v1/status',
    '/api/v1/auth/login',
  ],
}

Cuba.plugin Routes::Plugins::API

Cuba.define do
  on 'api' do
    on 'v1' do
      on get, 'status' do
        on root do
          res.json('{"status":"ok"}')
        end
      end

      on 'auth' do
        run Routes::Auth
      end
    end
  end
end
