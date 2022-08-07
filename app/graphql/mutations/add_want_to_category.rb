module Mutations
  class AddWantToCategory < BaseMutation
    field :want_to_category, Types::WantToCategoryType, null: true
    field :errors, [String], null: false

    argument :name, String, required: true, camelize: false
    argument :description, String, required: false, camelize: false
    argument :color, String, required: false, camelize: false
    argument :position, Integer, required: false, camelize: false

    def resolve(name:, description: nil, color: nil, position: nil)
      authorized?(context)

      want_to_category = WantToCategory.new(
        name: name,
        description: description,
        color: color,
        position: position,
        user: context[:current_user]
      )

      if want_to_category.save
        {
          want_to_category: want_to_category,
          errors: []
        }
      else
        {
          want_to_category: nil,
          errors: want_to_category.errors.full_messages
        }
      end
    end
  end
end
