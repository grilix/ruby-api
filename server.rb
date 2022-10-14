require 'cuba'
# require 'rack/jwt'

require './middleware/rack_jwt'

require './routes/plugins/api'
require './routes/auth'

require './db/connect'

Cuba.use(Middleware::RackJWT, {
  secret: ENV.fetch('HMAC_SECRET'),
})

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
