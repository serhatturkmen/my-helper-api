module Mutations
  class Signup < Mutations::BaseMutation
    graphql_name 'Signup'

    argument :username, String, required: true, camelize: false
    argument :email, String, required: true
    argument :password, String, required: true

    field :errors, [String], null: true
    field :user, Types::UserType, null: true

    def resolve(**args)
      user =
        User.new(
          username: args[:username],
          email: args[:email],
          password: args[:password]
        )

      if user.save
        context[:session][:token] = user.token

        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages.uniq }
      end
    end
  end
end
