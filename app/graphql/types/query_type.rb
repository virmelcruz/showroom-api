Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.
  
  field :floor, Types::FloorType do
    description 'Retrieve a floor by id'
    argument :id, !types.ID
    resolve -> (obj, args, ctx) {
      Floor.find(args[:id])
    }
  end

  field :floors, types[Types::FloorType] do
    description 'Retrieves all floors'
    resolve -> (obj, args, ctx) {
      Floor.all
    }
  end

  field :users, types[Types::UserType] do
    description 'Retrieves all users'
    resolve -> (obj, args, ctx) {
      User.all
    }
  end

end
