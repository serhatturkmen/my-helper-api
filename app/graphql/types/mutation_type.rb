module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::Login, camelize: false
    field :signup, mutation: Mutations::Signup, camelize: false
    field :add_want_to_category, mutation: Mutations::AddWantToCategory, camelize: false
  end
end
