module Types
  class BaseObject < GraphQL::Schema::Object
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
    field_class Types::BaseField

    def authorized?(ctx)
      raise GraphQL::ExecutionError, "You must be logged in to perform this action" if ctx[:current_user].nil?
    end
  end
end
