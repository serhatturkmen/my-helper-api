module Mutations
  class AddWantToItem < BaseMutation
    field :want_to_item, Types::WantToItemType, null: true
    field :errors, [String], null: false

    argument :name, String, required: true, camelize: false
    argument :want_to_category_id, ID, required: true, camelize: false
    argument :description, String, required: false, camelize: false
    argument :url, String, required: false, camelize: false
    argument :active, Boolean, required: false
    argument :position, Integer, required: false, camelize: false

    def resolve(name:, want_to_category_id:, description: nil, url: nil, active: nil, position: nil)
      authorized?(context)

      want_to_item = WantToItem.new(
        name: name,
        description: description,
        want_to_category_id: want_to_category_id,
      )

      want_to_item.url = url if url
      want_to_item.position = position if position
      want_to_item.active = active if active
      want_to_item.description = description if description

      if want_to_item.save
        {
          want_to_item: want_to_item,
          errors: []
        }
      else
        {
          want_to_item: nil,
          errors: want_to_item.errors.full_messages
        }
      end
    end
  end
end
