module Types
  class OptionType < Types::BaseObject
    field :key, ID, null: false
    field :label, String, null: true
  end
end
