module Types
  class WantToCategoryType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :description, String, null: true
    field :color, String, null: true
    field :position, Integer, null: true
    field :active, Boolean, null: true
    field :count, Integer, null: true
    field :user, UserType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
