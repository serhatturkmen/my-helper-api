module Mutations
  class UpdateProfile < BaseMutation
    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    argument :username, String, required: false
    argument :email, String, required: false

    def resolve(username:, email:)
      authorized?(context)

      unless context[:current_user]
        return {
          user: nil,
          errors: ['User not found.']
        }
      end

      user = User.find_by!(id: context[:current_user].id)
      user.email = email unless email.nil?
      user.username = username unless username.nil?

      if user.save
        {
          user: user.reload,
          errors: []
        }
      else
        {
          user: nil,
          errors: user.errors.full_messages
        }
      end
    end
  end
end
