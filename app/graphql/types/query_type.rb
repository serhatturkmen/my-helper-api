module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :user_information, UserType, null: false

    def user_information
      authorized?(context)

      context[:current_user]
    end

    field :want_to_categories, [WantToCategoryType], null: false

    def want_to_categories
      authorized?(context)

      WantToCategory.where(user_id: context[:current_user].id).includes(:want_to_items)
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

    field :want_to_items, [WantToItemType], null: false do
      argument :want_to_category_id, ID, required: true
    end

    def want_to_items(want_to_category_id:)
      authorized?(context)

      want_to_category = context[:current_user].want_to_categories.find(want_to_category_id)
      WantToItem.where(want_to_category: want_to_category)

    rescue ActiveRecord::RecordNotFound
      raise GraphQL::ExecutionError, "Could not find WantToCategory with id #{id}"
    end

    field :want_to_item, WantToItemType, null: false do
      argument :id, ID, required: true
    end

    def want_to_item(id:)
      authorized?(context)

      want_to_category_ids = context[:current_user].want_to_categories.pluck(:id)
      WantToItem.find_by(want_to_category_id: want_to_category_ids, id: id)

    rescue ActiveRecord::RecordNotFound
      raise GraphQL::ExecutionError, "Could not find WantToItem with id #{id}"
    end

    field :passive_want_to_items, [WantToItemType], null: false

    def passive_want_to_items
      authorized?(context)

      want_to_category_ids = context[:current_user].want_to_categories.pluck(:id)
      WantToItem.where(want_to_category_id: want_to_category_ids, active: false)
    end

    field :want_to_category_options, [Types::OptionType], null: false

    def want_to_category_options
      authorized?(context)

      want_to_categories = WantToCategory.where(user_id: context[:current_user].id).pluck(:name, :id)
      want_to_categories.map { |name, id| { label: name, key: id } }
    end

    field :search_want_to_item, [WantToItemType], null: false do
      argument :query, String, required: true
    end

    def search_want_to_item(query:)
      if query.blank?
        raise GraphQL::ExecutionError, "Query cannot be blank"
      end
      authorized?(context)

      want_to_category_ids = context[:current_user].want_to_categories.pluck(:id)
      WantToItem.where(want_to_category_id: want_to_category_ids).where("name ILIKE ?", "%#{query}%")
    end
  end
end
