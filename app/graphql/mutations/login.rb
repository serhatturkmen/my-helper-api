module Mutations
  class Login < Mutations::BaseMutation
    graphql_name 'Login'

    argument :username, String, required: true
    argument :password, String, required: true

    field :errors, [String], null: false
    field :user, Types::UserType, null: true

    def resolve(username:, password:)
      user = User.authenticate(username, password)

      if user.nil?
        { user: nil, errors: ['Username or password is wrong.'] }
      else
        context[:session][:token] = user.token
        { user: user, errors: [] }
      end
    end
  end
end
