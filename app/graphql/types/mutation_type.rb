Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  # TODO: Remove me
  field :testField, types.String do
    description "An example field added by the generator"
    resolve ->(obj, args, ctx) {
      "Hello World!"
    }
  end
  
  # for floors
  field :createFloor, function: Resolvers::Floor::CreateFloor.new
  field :updateFloor, function: Resolvers::Floor::UpdateFloor.new
  field :deleteFloor, function: Resolvers::Floor::DeleteFloor.new
  # for rooms
  field :createRoom, function: Resolvers::Room::CreateRoom.new
  field :updateRoom, function: Resolvers::Room::UpdateRoom.new
  field :deleteRoom, function: Resolvers::Room::DeleteRoom.new
  # for users
  field :createUser, function: Resolvers::User::CreateUser.new
end
