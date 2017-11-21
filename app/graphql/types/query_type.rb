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

  field :room, Types::RoomType do
    description 'Retrieve a floor by id'
    argument :id, !types.ID
    resolve -> (obj, args, ctx) {
      Room.find(args[:id])
    }
  end

  field :rooms, types[Types::RoomType] do
    description 'Retrieves all floors'
    resolve -> (obj, args, ctx) {
      Room.all
    }
  end

  field :users, types[Types::UserType] do
    description 'Retrieves all users'
    resolve -> (obj, args, ctx) {
      Rails.logger.info("executed meeeee! #{ctx[:current_user][:first_name]}")
      User.all
    }
  end

  field :user, Types::UserType do
    description 'Retrieves specific user by id'
    argument :id, !types.ID
    resolve -> (obj, args, ctx) {
      User.find(args[:id])
    }
  end

end
