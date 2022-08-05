module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::Login, camelize: false
    field :signup, mutation: Mutations::Signup, camelize: false
  end
end
