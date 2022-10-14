require 'bcrypt'

module Services
  module Users
    module Authentication
      def self.register_user(attributes)
        DB[:users].insert({
          username: attributes[:username],
          password_digest: BCrypt::Password.create(attributes[:password]).to_s,
        })
      end

      def self.authenticate(username, password)
        return if username.empty? || password.empty?

        user = DB[:users]
          .where(username: username)
          .select(:id, :username, :password_digest)
          .first

        return unless user && user[:password_digest] && !user[:password_digest].empty?

        return unless BCrypt::Password.new(user[:password_digest]) == password

        user.slice(:id, :username)
      end
    end
  end
end
