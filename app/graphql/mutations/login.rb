module Mutations
  class Login < Mutations::BaseMutation
    graphql_name 'Login'

    argument :email, String, required: true
    argument :password, String, required: true

    field :errors, [String], null: false
    field :user, Types::UserType, null: true

    def resolve(email:, password:)
      user = User.authenticate(email, password)

      if user.nil?
        { user: nil, errors: ['Email or password is wrong.'] }
      else
        context[:session][:token] = user.token
        { user: user, errors: [] }
      end
    end
  end
end
