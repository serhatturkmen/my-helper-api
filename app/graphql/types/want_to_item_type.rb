module Types
  class WantToItemType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :description, String, null: true
    field :url, String, null: true
    field :position, Integer, null: true
    field :active, Boolean, null: true
    field :want_to_category, WantToCategoryType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
