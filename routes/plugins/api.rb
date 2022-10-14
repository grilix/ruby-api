module Routes
  module Plugins
    module API
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
