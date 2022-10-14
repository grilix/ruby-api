module Routes
  module Plugins
    module API
      def require_jwt!
        return env['jwt.payload'] if env['jwt.valid']

        errors =
          if env['jwt.present']
            ['invalid token']
          else
            ['missing token']
          end

        json = JSON.generate({
          success: false,
        }.merge({ errors: errors }))

        res.status = 400 # TODO: ?
        res.json(json)
        halt(res.finish)
      end

      def success!(token, extra = {})
        res.headers['Authorization'] = "Bearer #{token}"

        json = JSON.generate({
          token: token,
          success: true,
        }.merge(extra))

        res.status = 200
        res.json(json)
        halt(res.finish)
      end

      def unprocessable_entity!(errors)
        json = JSON.generate({
          success: false,
        }.merge({ errors: errors }))

        res.status = 422
        res.json(json)
        halt(res.finish)
      end
    end
  end
end
