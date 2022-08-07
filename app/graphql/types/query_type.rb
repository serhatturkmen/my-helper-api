module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :users, [UserType], null: false

    def users
      authorized?(context)
      User.all
    end

    field :want_to_categories, [WantToCategoryType], null: false

    def want_to_categories
      authorized?(context)
      WantToCategory.where(user_id: context[:current_user].id)
    end

    field :want_to_category, WantToCategoryType, null: false do
      argument :id, ID, required: true
    end

    def want_to_category(id:)
      authorized?(context)
      context[:current_user].want_to_categories.find(id)

    rescue ActiveRecord::RecordNotFound
      raise GraphQL::ExecutionError, "Could not find WantToCategory with id #{id}"
    end
  end
end
